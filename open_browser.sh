#!/bin/sh

# Set the desired display
export DISPLAY=:20
LARAVEL_PATH="/home/macit/work-server-screen/"

# The URL to open is received as a parameter
URL_TO_OPEN="$1"

# Check if the URL to open is provided
if [ -z "$URL_TO_OPEN" ]; then
    echo "Error: No URL provided. Exiting... $(date)"
    exit 1
fi

# Get the current time in HH:MM format
CURRENT_TIME=$(date +"%H:%M")

# Parse JSON using jq
VARIABLES=$(php "$LARAVEL_PATH/artisan" variables)
SCHEDULED_EXECUTION_TIME=$(echo "$VARIABLES" | jq -r '.SCHEDULED_EXECUTION_TIME') # format: HH:MM

# If the current time does not match the scheduled execution time, stop the script
if [ "$CURRENT_TIME" != "$SCHEDULED_EXECUTION_TIME" ]; then
    echo "It's not the scheduled execution time. Exiting... $(date)"
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
    
    php "$LARAVEL_PATH"artisan add:activity "browser_opened"
    
    # Open the URL using chromium-browser path
    $CHROMIUM_PATH "$URL_TO_OPEN" &
fi

# Exit the script
exit 0
