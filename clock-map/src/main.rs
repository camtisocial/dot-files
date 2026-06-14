//! clock-map — a floating ratatui popup showing a map of the continental US
//! with the current local time in each of the four time zones, refreshed live.
//!
//! Launched by clicking the waybar clock pill (`kitty --class clock-map -e clock-map`).
//! Dismissal ("click away"): once the pointer has entered the popup, it closes the
//! moment the pointer leaves the window rectangle. This is polled against
//! `hyprctl cursorpos`/`clients` rather than focus events, because with
//! `input { follow_mouse = 1 }` the active-window signal only flips when the
//! cursor crosses onto another *window* (hovering the bar/gaps keeps it "focused"),
//! which made focus-based dismissal fire late/erratically. Esc / q also quit.

use std::process::Command;
use std::time::Duration;

use chrono::Utc;
use chrono_tz::Tz;
use ratatui::crossterm::event::{self, Event, KeyCode};
use ratatui::style::{Color, Style};
use ratatui::symbols::Marker;
use ratatui::text::Line;
use ratatui::widgets::canvas::{Canvas, Map, MapResolution, Rectangle};
use ratatui::widgets::Block;
use ratatui::Frame;

// Gruvbox palette, matching the waybar bar / gsimplecal popup.
const BG_FRAME: Color = Color::Rgb(0x92, 0x83, 0x74); // border / title (gruvbox gray)
const MAP_LAND: Color = Color::Rgb(0x66, 0x5c, 0x54); // coastlines (muted)

struct Zone {
    abbr: &'static str,
    tz: Tz,
    lon: f64,
    lat: f64,
    color: Color,
}

fn zones() -> Vec<Zone> {
    vec![
        Zone { abbr: "PT", tz: chrono_tz::America::Los_Angeles, lon: -118.24, lat: 34.05, color: Color::Rgb(0xfa, 0xbd, 0x2f) }, // yellow
        Zone { abbr: "MT", tz: chrono_tz::America::Denver,      lon: -104.99, lat: 39.74, color: Color::Rgb(0xb8, 0xbb, 0x26) }, // green
        Zone { abbr: "CT", tz: chrono_tz::America::Chicago,     lon:  -87.63, lat: 41.88, color: Color::Rgb(0xfe, 0x80, 0x19) }, // orange
        Zone { abbr: "ET", tz: chrono_tz::America::New_York,    lon:  -74.01, lat: 40.71, color: Color::Rgb(0x83, 0xa5, 0x98) }, // blue
    ]
}

fn main() {
    // CLOCK_MAP_NO_WATCH=1 disables click-away dismissal (debugging / screenshots).
    let watch = std::env::var_os("CLOCK_MAP_NO_WATCH").is_none();

    let mut terminal = ratatui::init();
    let _ = terminal.hide_cursor();
    let zones = zones();

    // Our own window rectangle (x, y, w, h). The window is already mapped by the
    // time the TUI runs, so this resolves on the first try; poll briefly for safety.
    let mut rect = None;
    if watch {
        for _ in 0..20 {
            rect = own_rect();
            if rect.is_some() {
                break;
            }
            std::thread::sleep(Duration::from_millis(50));
        }
    }
    // Latch: only start watching for "pointer left" after it has been inside once,
    // so the popup doesn't vanish before you've moved onto it.
    let mut entered = false;

    loop {
        let _ = terminal.draw(|f| draw(f, &zones));

        if let Some((x, y, w, h)) = rect {
            if let Some((cx, cy)) = cursor_pos() {
                let inside = cx >= x && cx < x + w && cy >= y && cy < y + h;
                if inside {
                    entered = true;
                } else if entered {
                    break; // pointer left the popup -> dismiss
                }
            }
        }

        // Short poll so the clock ticks and the pointer check stays responsive.
        if event::poll(Duration::from_millis(150)).unwrap_or(false) {
            if let Ok(Event::Key(k)) = event::read() {
                match k.code {
                    KeyCode::Esc | KeyCode::Char('q') | KeyCode::Char('Q') => break,
                    _ => {}
                }
            }
        }
    }
    ratatui::restore();
}

fn draw(f: &mut Frame, zones: &[Zone]) {
    let now = Utc::now();
    let canvas = Canvas::default()
        .block(
            Block::bordered()
                .title(" U.S. Time Zones ")
                .border_style(Style::default().fg(BG_FRAME))
                .title_style(Style::default().fg(BG_FRAME)),
        )
        // No background_color: cells stay unpainted so kitty's own (semi-
        // transparent) background shows through, picking up the Hyprland blur.
        .marker(Marker::Braille)
        // Bounding box around the lower-48, with a little margin so the map sits
        // slightly zoomed-out inside the window (tighten these to zoom back in).
        .x_bounds([-128.0, -63.0])
        .y_bounds([22.0, 52.0])
        .paint(move |ctx| {
            ctx.draw(&Map { color: MAP_LAND, resolution: MapResolution::High });
            // Markers + labels on their own layer, above the map. The city dot is
            // a printed glyph, not a Circle: a braille-sampled circle aliases to a
            // different blob per location, whereas "●" renders identically.
            ctx.layer();
            for z in zones {
                // Small hollow square outlined in braille dots, centered on the city.
                ctx.draw(&Rectangle { x: z.lon - 0.75, y: z.lat - 0.75, width: 1.5, height: 1.5, color: z.color });
                let t = now.with_timezone(&z.tz);
                let label = format!("{} {}", z.abbr, t.format("%-I:%M %p"));
                // Offset slightly west+north of the dot so the text doesn't sit
                // on the marker and stays inside the right/left edges.
                ctx.print(z.lon - 1.5, z.lat + 1.6, Line::styled(label, Style::default().fg(z.color)));
            }
        });
    f.render_widget(canvas, f.area());
}

/// `hyprctl cursorpos` -> "x, y".
fn cursor_pos() -> Option<(i64, i64)> {
    let out = Command::new("hyprctl").arg("cursorpos").output().ok()?;
    let s = String::from_utf8(out.stdout).ok()?;
    let mut it = s.trim().split(',');
    let x = it.next()?.trim().parse().ok()?;
    let y = it.next()?.trim().parse().ok()?;
    Some((x, y))
}

/// Our own window geometry via `hyprctl clients -j` (class `clock-map`).
fn own_rect() -> Option<(i64, i64, i64, i64)> {
    let out = Command::new("hyprctl").args(["clients", "-j"]).output().ok()?;
    let v: serde_json::Value = serde_json::from_slice(&out.stdout).ok()?;
    for c in v.as_array()? {
        if c.get("class")?.as_str()? == "clock-map" {
            let at = c.get("at")?.as_array()?;
            let size = c.get("size")?.as_array()?;
            return Some((
                at.first()?.as_i64()?,
                at.get(1)?.as_i64()?,
                size.first()?.as_i64()?,
                size.get(1)?.as_i64()?,
            ));
        }
    }
    None
}
