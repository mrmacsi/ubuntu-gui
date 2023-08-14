#!/bin/sh

# Set the desired display
export DISPLAY=:20
LARAVEL_PATH="/home/macit/work-server-screen/"

VARIABLES=$(php "$LARAVEL_PATH/artisan" variables)

CURRENT_HOUR=$(date +"%H")
CURRENT_MINUTE=$(date +"%M")

# Parse JSON using jq
START_HOUR=$(echo "$VARIABLES" | jq -r '.START_HOUR')
START_TIME=$(echo "$VARIABLES" | jq -r '.START_TIME')
END_HOUR=$(echo "$VARIABLES" | jq -r '.END_HOUR')
END_TIME=$(echo "$VARIABLES" | jq -r '.END_TIME')
EXECUTE=$(echo "$VARIABLES" | jq -r '.EXECUTE')

# If EXECUTE is not set to 'on', stop the script
if [ "$EXECUTE" != "on" ]; then
    echo "Execution is turned off. Exiting... $(date)"
    exit 0
fi

# If the current time is before the start hour and minute, stop the script
if [ "$CURRENT_HOUR" -lt "$START_HOUR" ] || ([ "$CURRENT_HOUR" -eq "$START_HOUR" ] && [ "$CURRENT_MINUTE" -lt "$START_TIME" ]); then
    echo "It's before the start time. Exiting... $(date)"
    exit 0
fi

# If the current time is after the end hour and minute, stop the script
if [ "$CURRENT_HOUR" -gt "$END_HOUR" ] || 
   ([ "$CURRENT_HOUR" -eq "$END_HOUR" ] && [ "$CURRENT_MINUTE" -ge "$((END_TIME-1))" ]); then
    echo "It's past the end time. Exiting... $(date)"
    exit 0
fi

# Try to find the location of Chromium
CHROMIUM_PATH=$(which chromium)
if [ -z "$CHROMIUM_PATH" ]; then
    echo "Error: Chromium not found."
    exit 1
fi

CHROMIUM_ID=$(xdotool search --name "chromium" | awk 'NR==2')

# If CHROMIUM_ID is empty, echo an error message and exit
if [ -z "$CHROMIUM_ID" ]; then
    # if Xvfb is not open start it
    if ! pgrep -f "Xvfb :20"; then
        Xvfb :20 -screen 0 1280x1024x24 &
        sleep 1
    fi
    
    php "$LARAVEL_PATH"artisan set:status "on"
    php "$LARAVEL_PATH"artisan add:activity "browser_opened"
    
    # Open the URL using chromium-browser path
    $CHROMIUM_PATH 'https://teams.microsoft.com/_?culture=en-gb&country=gb#/conversations/48:notes?ctx=chat' &
fi

# Exit the script
exit 0
