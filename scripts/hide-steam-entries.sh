#!/usr/bin/env bash
# Hide Steam's auto-generated per-game / runtime launcher entries from app
# launchers (wofi --show drun) by setting NoDisplay=true on them.
#
# Targets only entries whose Exec is `steam steam://rungameid/<id>` -- that
# covers the games AND the infrastructure junk (Steam Linux Runtime
# scout/soldier/sniper, Proton, SDKs, dedicated servers). The real Steam client
# (/usr/share/applications/steam.desktop) has a different Exec, so it stays
# visible and launchable.
#
# NoDisplay only hides from menus; `steam steam://rungameid/<id>` still works.
# Re-run after Steam adds new shortcuts (it may also re-sync and un-hide one).
set -euo pipefail

apps="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
hidden=0
shopt -s nullglob

for f in "$apps"/*.desktop; do
    grep -q '^Exec=steam steam://rungameid/' "$f" || continue
    if grep -q '^NoDisplay=' "$f"; then
        sed -i 's/^NoDisplay=.*/NoDisplay=true/' "$f"
    else
        sed -i '/^\[Desktop Entry\]/a NoDisplay=true' "$f"
    fi
    hidden=$((hidden + 1))
done

echo "Hid $hidden Steam launcher entries (games + runtimes). Steam client kept."
