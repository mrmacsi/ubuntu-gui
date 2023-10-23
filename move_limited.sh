#!/bin/bash

# Log file path
logfile="/home/macit/log.txt"

# Ensure the log file exists
if [ ! -f "$logfile" ]; then
    touch "$logfile"
fi

LARAVEL_PATH="/home/macit/work-server-screen/"
SCREENSHOT_FOLDER="screenshots/"
SCREENSHOT_DIRECTORY="${LARAVEL_PATH}storage/${SCREENSHOT_FOLDER}"

VARIABLES=$(php "$LARAVEL_PATH/artisan" variables)

CURRENT_HOUR=$(date +"%H")
CURRENT_MINUTE=$(date +"%M")

# Parse JSON using jq
START_HOUR=$(echo "$VARIABLES" | jq -r '.START_HOUR')
START_TIME=$(echo "$VARIABLES" | jq -r '.START_TIME')
END_HOUR=$(echo "$VARIABLES" | jq -r '.END_HOUR')
END_TIME=$(echo "$VARIABLES" | jq -r '.END_TIME')
SCREENSHOT_TIME=$(echo "$VARIABLES" | jq -r '.SCREENSHOT_TIME')
EXECUTE=$(echo "$VARIABLES" | jq -r '.EXECUTE')

# If EXECUTE is not set to 'on', stop the script
if [ "$EXECUTE" != "on" ]; then
    echo "Execution is turned off. Exiting... $(date)" >> $logfile
    exit 0
fi

# If the current time is before the start hour and minute, stop the script
if [ "$CURRENT_HOUR" -lt "$START_HOUR" ] || ([ "$CURRENT_HOUR" -eq "$START_HOUR" ] && [ "$CURRENT_MINUTE" -lt "$START_TIME" ]); then
    echo "It's before the start time. Exiting... $(date)" >> $logfile
    exit 0
fi

# If the current time is after the end hour and minute, stop the script
if [ "$CURRENT_HOUR" -gt "$END_HOUR" ] || ([ "$CURRENT_HOUR" -eq "$END_HOUR" ] && [ "$CURRENT_MINUTE" -gt "$END_TIME" ]); then
    echo "It's past the end time. Exiting... $(date)" >> $logfile
    exit 0
fi

echo "Script started at: $(date)" >> $logfile

export DISPLAY=:20

# Function to get the CHROMIUM_ID and check if it's empty
get_chromium_id() {
    CHROMIUM_ID=$(xdotool search --name "chromium" | awk 'NR==2')

    # If CHROMIUM_ID is empty, echo an error message and exit
    if [ -z "$CHROMIUM_ID" ]; then
        echo "Browser was closed at: $(date)" >> $logfile
        exit 1
    fi
}

CHROMIUM_ID=$(xdotool search --name "chromium" | awk 'NR==2')

echo "Display set to: $DISPLAY" >> $logfile
echo "Chromium Window ID: $CHROMIUM_ID" >> $logfile

# First invocation of the function
get_chromium_id

# Extracting X and Y positions of the Chromium window
X_POS=$(xdotool getwindowgeometry $CHROMIUM_ID | grep Position | awk '{print $2}' | cut -d',' -f1)
Y_POS=$(xdotool getwindowgeometry $CHROMIUM_ID | grep Position | awk '{print $2}' | cut -d',' -f2 | cut -d' ' -f1)
echo "Chromium Position: X=$X_POS, Y=$Y_POS" >> $logfile

# Extracting window dimensions
WINDOW_WIDTH=$(xdotool getwindowgeometry $CHROMIUM_ID | grep Geometry | awk '{print $2}' | cut -d'x' -f1)
WINDOW_HEIGHT=$(xdotool getwindowgeometry $CHROMIUM_ID | grep Geometry | awk '{print $2}' | cut -d'x' -f2)
echo "Chromium Dimensions: Width=$WINDOW_WIDTH, Height=$WINDOW_HEIGHT" >> $logfile

# Define padding
PADDING=200

# Adjust only the Y_POS and WINDOW_HEIGHT to account for padding at the top and bottom
Y_POS=$((Y_POS + PADDING))
WINDOW_HEIGHT=$((WINDOW_HEIGHT - 2*PADDING))

# Get the end time (current time + 30 seconds)
end_time=$(($(date +%s) + 30))

while [[ $(date +%s) -lt $end_time ]]; do
    # Check CHROMIUM_ID before moving
    get_chromium_id
    
    # Calculate random coordinates within the Chromium window with the padding on top and bottom
    x=$((X_POS + RANDOM % WINDOW_WIDTH))
    y=$((Y_POS + RANDOM % WINDOW_HEIGHT))

    # Log the coordinates to the terminal and log file
    echo "Moving mouse to: X=$x, Y=$y" | tee -a $logfile

    # Move the mouse to the computed location
    xdotool mousemove --sync $x $y

    sleep 6  # Adjust this if you want more or fewer moves within that 30 seconds.
done

if (( CURRENT_MINUTE % $SCREENSHOT_TIME == 0 )); then
    # Check if directory exists
    if [ ! -d "$SCREENSHOT_DIRECTORY" ]; then
        mkdir -p "$SCREENSHOT_DIRECTORY"
        echo "Directory $SCREENSHOT_DIRECTORY created."
    fi
    
    # Get the current timestamp
    TIMESTAMP=$(date +"%Y%m%d%H%M%S")
    X_POS=0
    Y_POS=$(xdotool getwindowgeometry $CHROMIUM_ID | grep Position | awk '{print $2}' | cut -d',' -f2 | cut -d' ' -f1)
    # Extracting window dimensions
    WINDOW_WIDTH=$(xdotool getwindowgeometry $CHROMIUM_ID | grep Geometry | awk '{print $2}' | cut -d'x' -f1)
    WINDOW_HEIGHT=$(xdotool getwindowgeometry $CHROMIUM_ID | grep Geometry | awk '{print $2}' | cut -d'x' -f2)
    
    echo "WINDOW_WIDTH: $WINDOW_WIDTH" >> "$logfile"
    echo "WINDOW_HEIGHT: $WINDOW_HEIGHT" >> "$logfile"
    echo "X_POS: $X_POS" >> "$logfile"
    echo "Y_POS: $Y_POS" >> "$logfile"
    echo "TIMESTAMP: $TIMESTAMP" >> "$logfile"
    
    # Capture a screenshot of the Chromium window with the timestamp in the filename
    import -window "$CHROMIUM_ID" -crop "${WINDOW_WIDTH}x${WINDOW_HEIGHT}+${X_POS}+${Y_POS}" "${SCREENSHOT_DIRECTORY}screenshot_${TIMESTAMP}.png"
    
    php "$LARAVEL_PATH"artisan screenshot:log "screenshot_${TIMESTAMP}.png" "macit@codepark.co.uk"
    
    echo "Screenshot screenshot_${TIMESTAMP}.png taken." >> $logfile
fi

echo "Script finished at: $(date) and exited." >> $logfile
