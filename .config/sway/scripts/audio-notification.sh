#!/bin/bash

# Script to create pop-up notification when volume changes.

# Create a delay so the change in volume can be registered:
sleep 0.05

# Get the volume and check if muted or not (STATE):
VOLUME=`pulsemixer --get-volume | awk '{ print $1 }'`

# Future: get volume via "wpctl get-volume @DEFAULT_AUDIO_SINK@" and get rid of pulsemixer.

STATE=`amixer -D pulse sget Master          | \
       grep -E -m 1 'Playback.*?\[o' | \
       grep -E -o '\[o.+\]'`

# Have a different symbol for varying volume levels:
if [[ $STATE != '[off]' ]]; then
        if [ "${VOLUME}" == "0" ]; then
                ICON=~/.config/icons/vol-mute.png
        elif [ "${VOLUME}" -lt "33" ] && [ $VOLUME -gt "0" ]; then
                ICON=~/.config/icons/vol-low.png
        elif [ "${VOLUME}" -lt "90" ] && [ $VOLUME -ge "33" ]; then
                ICON=~/.config/icons/vol-med.png
        else
                ICON=~/.config/icons/vol-high.png
        fi

        ~/sway/notify-send.sh/notify-send.sh "Volume: $VOLUME%" \
            --replace-file=/tmp/audio-notification \
            -t 2000 \
            -i ${ICON} \
            -h int:value:${VOLUME} \
            -h string:synchronous:volume-change

# If volume is muted, display the mute sybol:
else
        ~/sway/notify-send.sh/notify-send.sh "Muted (volume: $VOLUME%)" \
            --replace-file=/tmp/audio-notification \
            -t 2000 \
            -i ~/.config/icons/vol-mute.png \
            -h int:value:${VOLUME} \
            -h string:synchronous:volume-change
fi
