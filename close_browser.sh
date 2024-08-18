#!/bin/bash

LARAVEL_PATH="/home/macit/work-server-screen/"
SCREENSHOT_FOLDER="screenshots/"
SCREENSHOT_DIRECTORY="${LARAVEL_PATH}storage/${SCREENSHOT_FOLDER}"

VARIABLES=$(php "$LARAVEL_PATH/artisan" variables)

# Parse JSON using jq to get the FLIGHT_STATUS
FLIGHT_STATUS=$(echo "$VARIABLES" | jq -r '.FLIGHT_STATUS')

# Check if FLIGHT_STATUS is false
if [ "$FLIGHT_STATUS" == "false" ]; then
  # Kill the Chromium process
  pkill -f chromium

  # Log the activity
  php "$LARAVEL_PATH/artisan" add:activity "browser_closed"

  php "$LARAVEL_PATH/artisan" set:flight "on"

  echo "Google Flights on Chromium closed."
fi

# Exit the script
exit 0
