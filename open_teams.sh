#!/bin/sh

# Set the desired display
export DISPLAY=:20

# Start Xvfb on display :20
Xvfb :20 -screen 0 1280x1024x24 &

# Wait for Xvfb to start (a brief delay)
sleep 1

# Try to find the location of Chromium
CHROMIUM_PATH=$(which chromium)
if [ -z "$CHROMIUM_PATH" ]; then
    echo "Error: Chromium not found."
    exit 1
fi

# Open the URL using chromium-browser path
$CHROMIUM_PATH 'https://teams.microsoft.com/_?culture=en-gb&country=gb#/conversations/48:notes?ctx=chat' &

# Exit the script
exit 0
