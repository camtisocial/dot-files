#!/usr/bin/env bash
#
# audio-output.sh -- switch the default audio output (sink).
#
# Modes:
#   audio-output.sh --slot N   Switch to the Nth device in audio-menu.map.
#                              Used by the waybar right-click dropdown.
#   audio-output.sh            Pick from a wofi menu (standalone / fallback).
#
# The dropdown's device list is produced by gen-audio-menu.sh into:
#   audio-menu.xml  (the GTK menu waybar renders)
#   audio-menu.map  (slot index -> sink name, one per line)
#
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAP="$DIR/audio-menu.map"

notify() { command -v notify-send >/dev/null && notify-send -t 2500 "$@" || true; }

command -v pactl >/dev/null || { notify "audio-output" "pactl not found"; exit 1; }

# Make $1 the default sink and move any playing streams onto it so sound follows.
switch() {
    local name="$1" desc
    pactl set-default-sink "$name"
    while read -r id _; do
        [ -n "$id" ] && pactl move-sink-input "$id" "$name" 2>/dev/null || true
    done < <(pactl list short sink-inputs)
    desc="$(DEFAULT="$name" pactl -f json list sinks | python3 -c '
import json, os, sys
n = os.environ["DEFAULT"]
print(next((s.get("description") or s["name"] for s in json.load(sys.stdin) if s["name"] == n), n))
' 2>/dev/null || echo "$name")"
    notify "Audio output" "$desc"
}

# --- Dropdown mode: resolve a slot index from the generated map ------------
if [ "${1:-}" = "--slot" ]; then
    n="${2:-}"
    name="$(sed -n "$(( ${n:-0} + 1 ))p" "$MAP" 2>/dev/null || true)"
    [ -n "$name" ] || { notify "audio-output" "no device in slot ${n:-?}"; exit 1; }
    switch "$name"
    exit 0
fi

# --- Standalone mode: wofi picker ------------------------------------------
command -v wofi >/dev/null || { notify "audio-output" "wofi not found"; exit 1; }
default="$(pactl get-default-sink 2>/dev/null || true)"
menu="$(DEFAULT="$default" pactl -f json list sinks | python3 -c '
import json, os, sys
default = os.environ.get("DEFAULT", "").strip()
for s in json.load(sys.stdin):
    name = s["name"]; desc = s.get("description") or name
    mark = "●" if name.strip() == default else "○"
    print(f"{mark} {desc}\t{name}")
')"
[ -n "$menu" ] || { notify "audio-output" "no output devices found"; exit 1; }
choice="$(cut -f1 <<<"$menu" | wofi --dmenu -i -p "Output device")" || choice=""
[ -n "$choice" ] || exit 0
name="$(awk -F'\t' -v c="$choice" '$1 == c {print $2; exit}' <<<"$menu")"
[ -n "$name" ] || exit 0
switch "$name"
