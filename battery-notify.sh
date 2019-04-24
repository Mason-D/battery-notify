#! /bin/bash

#.--.       .  .                .   .     .       .-.
#|   )     _|__|_               |\  |    _|_   o  |
#|--:  .-.  |  |  .-. .--..  .  | \ | .-. |    . -|-.  .
#|   )(   ) |  | (.-' |   |  |  |  \|(   )|    |  | |  |
#'--'  `-'`-`-'`-'`--''   `--|  '   ' `-' `-'-' `-' `--|
#                            ;                         ;
#                         `-'                       `-'

# How long to sleep between each iteration
TIMEOUT=1

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

# Status for various notifications
# true = send | false = don't send
# 1 - 5% (Discharging)
# 2 - 10% (Discharging)
# 3 - 15% (Discharging)
# 4 - 20% (Discharging)
# 5 - 30% (Discharging)
# 6 - 50% (Discharging)
# 7 - 100% (Charging)
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
    echo Status changed from $LAST_STATUS to "$STATUS"
    notify "Battery: $STATUS" 3
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

    # Send notification based on status and battery level
    if [[ "$STATUS" = "$DISCHARGING" ]]; then
        if   ${NOTIFICATIONS[6]} && [[ $BAT_LEVEL -le 50 ]]; then
            NOTIFICATIONS[6]=false
            notify "Battery: 50% Charge remaining"
        elif ${NOTIFICATIONS[5]} && [[ $BAT_LEVEL -le 30 ]]; then
            NOTIFICATIONS[5]=false
            notify "Battery: 30% Charge remaining"
        elif ${NOTIFICATIONS[4]} && [[ $BAT_LEVEL -le 20 ]]; then
            NOTIFICATIONS[4]=false
            notify "Battery: 20% Charge remaining"
        elif ${NOTIFICATIONS[3]} && [[ $BAT_LEVEL -le 15 ]]; then
            NOTIFICATIONS[3]=false
            notify "Battery: 15% Charge remaining"
        elif ${NOTIFICATIONS[2]} && [[ $BAT_LEVEL -le 10 ]]; then
            NOTIFICATIONS[2]=false
            notify "Battery: 10% Charge remaining"
        elif ${NOTIFICATIONS[1]} && [[ $BAT_LEVEL -le 5 ]]; then
            NOTIFICATIONS[1]=false
            notify "Battery: 5% Charge remaining"
        fi
    elif [[ "$STATUS" = "$CHARGING" ]]; then
        echo
    fi

    # Sleep for $TIMEOUT to save resources
    sleep $TIMEOUT
done
