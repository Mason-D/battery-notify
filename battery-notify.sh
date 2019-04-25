#! /bin/bash

#.--.       .  .                .   .     .       .-.
#|   )     _|__|_               |\  |    _|_   o  |
#|--:  .-.  |  |  .-. .--..  .  | \ | .-. |    . -|-.  .
#|   )(   ) |  | (.-' |   |  |  |  \|(   )|    |  | |  |
#'--'  `-'`-`-'`-'`--''   `--|  '   ' `-' `-'-' `-' `--|
#                            ;                         ;
#                         `-'                       `-'

# How long to sleep between each iteration
TIMEOUT=10

# Location of status file
STATUS_FILE='/sys/class/power_supply/BAT?/status'

# Location of the battery level file
BAT_LEVEL_FILE='/sys/class/power_supply/BAT?/capacity'

# The previous status to detect change
LAST_STATUS='NULL'

# Status for Unplugged
DISCHARGING='Discharging'

# Status for Plugged
CHARGING='Charging'

# Prefix for all alerts
PREFIX='Battery:'

# Status for various notifications
# true = send | false = don't send
# 0 - 5% (Discharging)
# 1 - 10% (Discharging)
# 2 - 15% (Discharging)
# 3 - 20% (Discharging)
# 4 - 30% (Discharging)
# 5 - 50% (Discharging)
# 6 - 100% (Charging)
NOTIFICATIONS=(true true true true true true true)

# Send a user notification
# notify <data> <length - seconds>
function notify () {
    DATA="$1"
    EXPIRE=`expr ${2-5} \* 1000`

    notify-send --urgency=normal \
                --expire-time="$EXPIRE" \
                --app-name=battery-notify \
                "$DATA"
}

# This function is called anytime the battery status changes
# status_change <status>
function status_change () {
    STATUS="$1"
    echo "$LAST_STATUS -> $STATUS @ ${BAT_LEVEL}% | Notifying"
    notify "$PREFIX $STATUS" 3
}

# Main Loop
while true; do
    # Retreive Battery Status
    STATUS=`cat $STATUS_FILE`
    BAT_LEVEL=`cat $BAT_LEVEL_FILE`

    # Handle Status Changes
    if [[ "$STATUS" != "$LAST_STATUS" ]]; then
        status_change "$STATUS"
        LAST_STATUS="$STATUS"
    fi

    # Handle Discharging Events
    if [[ "$STATUS" = "$DISCHARGING" ]]; then
        # Send low battery notifications
        if   ${NOTIFICATIONS[5]} && [[ $BAT_LEVEL -le 50 ]]; then
            echo "$PREFIX $STATUS - ${BAT_LEVEL}% | Notifying"
            NOTIFICATIONS[5]=false
            notify "$PREFIX ${BAT_LEVEL}% Charge remaining"

        elif ${NOTIFICATIONS[4]} && [[ $BAT_LEVEL -le 30 ]]; then
            echo "$PREFIX $STATUS - ${BAT_LEVEL}% | Notifying"
            NOTIFICATIONS[4]=false
            notify "$PREFIX ${BAT_LEVEL}% Charge remaining"

        elif ${NOTIFICATIONS[3]} && [[ $BAT_LEVEL -le 20 ]]; then
            echo "$PREFIX $STATUS - ${BAT_LEVEL}% | Notifying"
            NOTIFICATIONS[3]=false
            notify "$PREFIX ${BAT_LEVEL}% Charge remaining"

        elif ${NOTIFICATIONS[2]} && [[ $BAT_LEVEL -le 15 ]]; then
            echo "$PREFIX $STATUS - ${BAT_LEVEL}% | Notifying"
            NOTIFICATIONS[2]=false
            notify "$PREFIX ${BAT_LEVEL}% Charge remaining"

        elif ${NOTIFICATIONS[1]} && [[ $BAT_LEVEL -le 10 ]]; then
            echo "$PREFIX $STATUS - ${BAT_LEVEL}% | Notifying"
            NOTIFICATIONS[1]=false
            notify "$PREFIX ${BAT_LEVEL}% Charge remaining"

        elif ${NOTIFICATIONS[0]} && [[ $BAT_LEVEL -le 5 ]]; then
            echo "$PREFIX $STATUS - ${BAT_LEVEL}% | Notifying"
            NOTIFICATIONS[0]=false
            notify "$PREFIX ${BAT_LEVEL}% Charge remaining"
        fi

        # Reset full battery notification
        if ! ${NOTIFICATIONS[6]} && [[ $BAT_LEVEL -lt 100 ]]; then
            NOTIFICATIONS[6]=true
        fi

    # Handle Charging Events
    elif [[ "$STATUS" = "$CHARGING" ]]; then
        # Reset low battery notifications
        if ! ${NOTIFICATIONS[0]} && [[ $BAT_LEVEL -gt 5 ]]; then
            NOTIFICATIONS[0]=true
        fi

        if ! ${NOTIFICATIONS[1]} && [[ $BAT_LEVEL -gt 10 ]]; then
            NOTIFICATIONS[1]=true
        fi

        if ! ${NOTIFICATIONS[2]} && [[ $BAT_LEVEL -gt 15 ]]; then
            NOTIFICATIONS[2]=true
        fi

        if ! ${NOTIFICATIONS[3]} && [[ $BAT_LEVEL -gt 20 ]]; then
            NOTIFICATIONS[3]=true
        fi

        if ! ${NOTIFICATIONS[4]} && [[ $BAT_LEVEL -gt 30 ]]; then
            NOTIFICATIONS[4]=true
        fi

        if ! ${NOTIFICATIONS[5]} && [[ $BAT_LEVEL -gt 50 ]]; then
            NOTIFICATIONS[5]=true
        fi

        # Send full battery notification
        if ${NOTIFICATIONS[6]} && [[ $BAT_LEVEL -ge 100 ]]; then
            echo "$PREFIX $STATUS - ${BAT_LEVEL}% | Notifying"
            NOTIFICATIONS[6]=false
            notify "$PREFIX Full Charge"
        fi
    fi

    # Sleep for $TIMEOUT to save resources
    sleep $TIMEOUT
done
