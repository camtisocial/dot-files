#!/usr/bin/env bash
#
# audio-menu-watch.sh -- keep the waybar right-click output menu in sync with
# hot-plugged audio devices.
#
# waybar reads menu-file (audio-menu.xml) only when a bar is created, so a menu
# baked at startup goes stale the moment you (un)plug a sink. This watches
# `pactl subscribe` for sinks appearing/disappearing, regenerates the menu+map
# via gen-audio-menu.sh, and SIGUSR2s waybar to reload it.
#
# Backgrounded by launch.sh (which guards against duplicate watchers).
#
set -u
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
command -v pactl >/dev/null || exit 0

regen() {
    "$DIR/gen-audio-menu.sh" 2>/dev/null || return 0
    # SIGUSR2 = waybar "reload config": it recreates the bar, which re-reads the
    # freshly written audio-menu.xml. (signal:8 only re-runs the volume exec.)
    pkill -USR2 -x waybar 2>/dev/null || true
}

# A single (un)plug emits a burst of events; debounce so we regen+reload once.
pending=
trigger() {
    [ -n "$pending" ] && kill "$pending" 2>/dev/null
    { sleep 0.4; regen; } &
    pending=$!
}

# Respawn the subscription if pipewire-pulse restarts under us.
while true; do
    # Lines look like: "Event 'new' on sink #56". React only to sinks being
    # added/removed -- 'change' fires on every volume tweak and would spam reloads.
    pactl subscribe 2>/dev/null | while read -r _ ev _ obj _; do
        [ "$obj" = sink ] || continue
        case "$ev" in
            "'new'"|"'remove'") trigger ;;
        esac
    done
    sleep 1
done
