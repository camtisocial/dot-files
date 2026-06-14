#!/usr/bin/env bash
#
# launch.sh -- start waybar, regenerating the output-device dropdown from the
# current PipeWire devices first (so the right-click menu is always accurate).
# Wired in hyprland.conf:  exec-once = ~/.config/waybar/launch.sh
#
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"$DIR/gen-audio-menu.sh" 2>/dev/null || true
exec waybar "$@"
