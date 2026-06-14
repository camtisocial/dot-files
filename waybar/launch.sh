#!/usr/bin/env bash
#
# launch.sh -- start waybar, regenerating the output-device dropdown from the
# current PipeWire devices first (so the right-click menu is accurate at start),
# plus a watcher that keeps that menu in sync as devices are hot-plugged.
# Wired in hyprland.conf:  exec-once = ~/.config/waybar/launch.sh
#
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Keep the right-click menu fresh on device hot-plug. Guard against duplicates
# so re-running launch.sh doesn't stack watchers, then detach it from this shell.
pkill -f "$DIR/audio-menu-watch.sh" 2>/dev/null || true
setsid "$DIR/audio-menu-watch.sh" >/dev/null 2>&1 </dev/null &

# Supervise waybar: it's the GTK3 build and segfaults occasionally -- the mpris
# module on libplayerctl signals, plus GTK/Wayland event races -- so respawn it
# instead of leaving a dead bar. Regenerate the device menu before each (re)start.
# A clean exit or SIGTERM/SIGINT (logout, manual kill) ends the loop; a crash
# (e.g. 139 SIGSEGV) respawns after a short pause to avoid a hot loop.
while true; do
    "$DIR/gen-audio-menu.sh" 2>/dev/null || true
    waybar "$@"
    case "$?" in 0|130|143) break ;; esac
    sleep 1
done
