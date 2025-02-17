#!/bin/bash
while true; do
    VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}')
    if (( $(echo "$VOLUME > 1.0" | bc -l) )); then
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 1.0
    fi
    sleep 0.5
done

