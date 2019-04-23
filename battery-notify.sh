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
NOTIFY_TIMEOUT=`expr 1000 \* $TIMEOUT + 1`

# Location of status file
STATUS_FILE='/sys/class/power_supply/BAT?/status'

# Location of the battery level file
BAT_LEVEL_FILE='/sys/class/power_supply/BAT?/capacity'

# The previous status to detect change
LAST_STATUS=''

# This function is called anytime the battery status changes
function status_change () {
    STATUS="$1"
    echo "$STATUS"
}

# Main Loop
while true; do
    # Retreive Battery Status
    STATUS=`cat $STATUS_FILE`
    BAT_LEVEL=`cat $STATUS_FILE`

    # Handle Status Changes
    if [ "$STATUS" != "$LAST_STATUS" ]; then
        status_change "$STATUS"
        LAST_STATUS="$STATUS"
    fi

    # Sleep for $TIMEOUT to save resources
    sleep $TIMEOUT
done
