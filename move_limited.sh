#!/bin/bash

# Log file path
logfile="/home/macit/log.txt"

# Ensure the log file exists
if [ ! -f "$logfile" ]; then
    touch "$logfile"
fi

echo "Script started at: $(date)" >> $logfile
echo "Display set to: $DISPLAY" >> $logfile

export DISPLAY=:20

# Get the second occurrence of a window named "chromium"
CHROMIUM_ID=$(xdotool search --name "chromium" | awk 'NR==2')

# If CHROMIUM_ID is empty, echo an error message and exit
if [ -z "$CHROMIUM_ID" ]; then
    echo "Browser is closed." >&2
    exit 1
fi

echo "Chromium Window ID: $CHROMIUM_ID" >> $logfile

# Extracting X and Y positions of the Chromium window
X_POS=$(xdotool getwindowgeometry $CHROMIUM_ID | grep Position | awk '{print $2}' | cut -d',' -f1)
Y_POS=$(xdotool getwindowgeometry $CHROMIUM_ID | grep Position | awk '{print $2}' | cut -d',' -f2 | cut -d' ' -f1)
echo "Chromium Position: X=$X_POS, Y=$Y_POS" >> $logfile

# Extracting window dimensions
WINDOW_WIDTH=$(xdotool getwindowgeometry $CHROMIUM_ID | grep Geometry | awk '{print $2}' | cut -d'x' -f1)
WINDOW_HEIGHT=$(xdotool getwindowgeometry $CHROMIUM_ID | grep Geometry | awk '{print $2}' | cut -d'x' -f2)
echo "Chromium Dimensions: Width=$WINDOW_WIDTH, Height=$WINDOW_HEIGHT" >> $logfile

# Define padding
PADDING=350

# Adjust only the Y_POS and WINDOW_HEIGHT to account for padding at the top and bottom
Y_POS=$((Y_POS + PADDING))
WINDOW_HEIGHT=$((WINDOW_HEIGHT - 2*PADDING))

# Get the end time (current time + 30 seconds)
end_time=$(($(date +%s) + 30))

while [[ $(date +%s) -lt $end_time ]]; do
    # Calculate random coordinates within the Chromium window with the padding on top and bottom
    x=$((X_POS + RANDOM % WINDOW_WIDTH))
    y=$((Y_POS + RANDOM % WINDOW_HEIGHT))

    # Log the coordinates to the terminal and log file
    echo "Moving mouse to: X=$x, Y=$y" | tee -a $logfile

    # Move the mouse to the computed location
    xdotool mousemove --sync $x $y

    sleep 1  # Adjust this if you want more or fewer moves within that 30 seconds.
done

echo "Script finished at: $(date) and exited." >> $logfile
