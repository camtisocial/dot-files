#!/usr/bin/env bash
# Volume / brightness OSD via dunst.
#
# Adjusts the level, then shows ONE notification that updates in place: the
# `x-dunst-stack-tag` hint makes dunst replace the previous popup sharing that
# tag instead of stacking, and `int:value` draws the gruvbox progress bar.
# Appname "osd" is matched by the [osd] rule in dunstrc (short timeout, kept out
# of history). Wired to the waybar volume pill (scroll + mute click) and, on the
# laptop, the existing XF86 brightness keys.
#
# Icons are nerd-font glyphs (rendered by dunst's JetBrainsMono Nerd Font),
# not freedesktop icon-theme images -- so they match the bar's text style.
set -euo pipefail

SINK="@DEFAULT_AUDIO_SINK@"
STEP_VOL=5
STEP_BRIGHT=10

# Nerd-font glyphs (Font Awesome set); $'\u..' avoids embedding raw PUA chars.
G_VOL_HIGH=$''   #
G_VOL_MID=$''    #
G_VOL_LOW=$''    #
G_MUTED=$''      #  (same glyph the bar uses for muted)
G_BRIGHT=$''     #

osd() { # value  glyph  label  body  stack-tag
    dunstify -a osd -u low \
        -h "string:x-dunst-stack-tag:$5" \
        -h "int:value:$1" "$2  $3" "$4"
}

volume() {
    local out vol glyph
    out=$(wpctl get-volume "$SINK")          # e.g. "Volume: 0.65 [MUTED]"
    vol=$(awk '{printf "%d", $2 * 100}' <<<"$out")
    if [[ "$out" == *MUTED* ]]; then
        osd 0 "$G_MUTED" "Volume" "muted" osd-vol
    else
        glyph=$G_VOL_HIGH
        (( vol < 34 )) && glyph=$G_VOL_LOW
        (( vol >= 34 && vol < 67 )) && glyph=$G_VOL_MID
        osd "$vol" "$glyph" "Volume" "${vol}%" osd-vol
    fi
    # Repaint waybar's volume pill (custom/volume module, "signal": 8).
    pkill -RTMIN+8 -x waybar 2>/dev/null || true
}

brightness() {
    local pct
    pct=$(brightnessctl -m 2>/dev/null | awk -F, 'NR==1{gsub(/%/,"",$4); print $4}')
    [[ -z "$pct" ]] && exit 0   # no backlight device (e.g. desktop monitor) -> nothing to show
    osd "$pct" "$G_BRIGHT" "Brightness" "${pct}%" osd-bright
}

case "${1:-}" in
    vol-up)      wpctl set-mute "$SINK" 0; wpctl set-volume -l 1.0 "$SINK" ${STEP_VOL}%+; volume ;;
    vol-down)    wpctl set-mute "$SINK" 0; wpctl set-volume      "$SINK" ${STEP_VOL}%-;   volume ;;
    vol-mute)    wpctl set-mute "$SINK" toggle;                                           volume ;;
    bright-up)   brightnessctl -q s ${STEP_BRIGHT}%+; brightness ;;
    bright-down) brightnessctl -q s ${STEP_BRIGHT}%-; brightness ;;
    *) echo "usage: ${0##*/} {vol-up|vol-down|vol-mute|bright-up|bright-down}" >&2; exit 1 ;;
esac
