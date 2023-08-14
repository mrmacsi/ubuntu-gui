#!/bin/bash

LARAVEL_PATH="/home/macit/work-server-screen/"

php "$LARAVEL_PATH"artisan set:status "off"

# Kill the Chromium process
pkill -f chromium

php "$LARAVEL_PATH"artisan add:activity "browser_closed"

echo "Teams on Chromium closed."

# Exit the script
exit 0
