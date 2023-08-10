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
echo "Chromium Window ID: $CHROMIUM_ID" >> $logfile

# NOTE: You assigned the ID to CHROMIUM_ID but were using $WINDOW_ID. This is an error in your script.
# I've changed it to use $CHROMIUM_ID in the following lines:

# Extracting X and Y positions of the Chromium window
X_POS=$(xdotool getwindowgeometry $CHROMIUM_ID | grep Position | awk '{print $2}' | cut -d',' -f1)
Y_POS=$(xdotool getwindowgeometry $CHROMIUM_ID | grep Position | awk '{print $2}' | cut -d',' -f2 | cut -d' ' -f1)
echo "Chromium Position: X=$X_POS, Y=$Y_POS" >> $logfile

# Extracting window dimensions
WINDOW_WIDTH=$(xdotool getwindowgeometry $CHROMIUM_ID | grep Geometry | awk '{print $2}' | cut -d'x' -f1)
WINDOW_HEIGHT=$(xdotool getwindowgeometry $CHROMIUM_ID | grep Geometry | awk '{print $2}' | cut -d'x' -f2)
echo "Chromium Dimensions: Width=$WINDOW_WIDTH, Height=$WINDOW_HEIGHT" >> $logfile

# Calculate the center of the Chromium window
center_x=$((X_POS + WINDOW_WIDTH / 2))
center_y=$((Y_POS + WINDOW_HEIGHT / 2))
echo "Chromium Center Position: X=$center_x, Y=$center_y" >> $logfile

# Get the end time (current time + 30 seconds)
end_time=$(($(date +%s) + 30))

while [[ $(date +%s) -lt $end_time ]]; do
    range=200  # Define a range for randomness, e.g., 300 pixels in any direction

    # Calculate random offsets from the center
    random_x=$((RANDOM % (range*2 + 1) - range))
    random_y=$((RANDOM % (range*2 + 1) - range))

    # Compute the final random coordinates near the center of the Chromium window
    x=$((center_x + random_x))
    y=$((center_y + random_y))

    # Log the coordinates to the terminal and log file
    echo "Moving mouse to: X=$x, Y=$y" | tee -a $logfile

    # Move the mouse to the computed location
    xdotool mousemove $x $y

    sleep 1  # Adjust this if you want more or fewer moves within that 30 seconds.
done

echo "Script finished at: $(date) and exited." >> $logfile
