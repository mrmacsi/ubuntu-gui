#!/bin/sh

# Set the desired display
export DISPLAY=:20
LARAVEL_PATH="/home/macit/work-server-screen/"

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
    php "$LARAVEL_PATH"artisan add:activity "browswer_opened"
    
    # Open the URL using chromium-browser path
    $CHROMIUM_PATH 'https://teams.microsoft.com/_?culture=en-gb&country=gb#/conversations/48:notes?ctx=chat' &
fi

# Exit the script
exit 0
