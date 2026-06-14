#!/usr/bin/env bash
# Volume pill for waybar, driven by the SAME default sink that osd.sh controls.
#
# Why a custom module instead of waybar's built-in "wireplumber" one:
# the real default sink on this box is an snd-aloop loopback (so cava can tap
# its monitor ports). waybar's wireplumber module conflates the *configured*
# default (the MOTU) with the *runtime* default (the loopback) and so never
# reflects the mute we apply to @DEFAULT_AUDIO_SINK@. Reading wpctl directly --
# the exact node osd.sh mutes -- sidesteps that entirely and works on either
# machine (loopback default or plain hardware default).
#
# Emits waybar JSON: text + a CSS class ("muted"/"unmuted") so style.css can
# colour the pill. Refreshed instantly by osd.sh, which sends SIGRTMIN+8 after
# every change (see "signal": 8 on the custom/volume module).
set -euo pipefail

SINK="@DEFAULT_AUDIO_SINK@"

# Nerd-font glyphs -- identical to osd.sh and the old wireplumber format-icons.
G_LOW=$''    #
G_MID=$''    #
G_HIGH=$''   #
G_MUTED=$''  #

out=$(wpctl get-volume "$SINK" 2>/dev/null) || { printf '{"text":""}\n'; exit 0; }
vol=$(awk '{printf "%d", $2 * 100}' <<<"$out")   # "Volume: 0.65 [MUTED]" -> 65

if [[ "$out" == *MUTED* ]]; then
    printf '{"text":"%s","class":"muted","tooltip":false}\n' "$G_MUTED"
else
    if   (( vol < 34 )); then glyph=$G_LOW
    elif (( vol < 67 )); then glyph=$G_MID
    else                      glyph=$G_HIGH
    fi
    printf '{"text":"%s  %d%%","class":"unmuted","tooltip":false}\n' "$glyph" "$vol"
fi
