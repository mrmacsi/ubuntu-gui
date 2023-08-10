#!/bin/bash

# Log file path
logfile="/home/macit/log.txt"

if [ ! -f "$logfile" ]; then
    touch "$logfile"
fi

# Log the start time to the file
echo "Script started at: $(date)" >> $logfile

export DISPLAY=:20

WINDOW_ID=37748738  # The ID of your Chromium window

# Extracting X and Y positions of the Chromium window
X_POS=$(xdotool getwindowgeometry $WINDOW_ID | grep Position | awk -F'[x,]' '{print $1}' | awk '{print $2}')
Y_POS=$(xdotool getwindowgeometry $WINDOW_ID | grep Position | awk -F'[x,]' '{print $2}')

# Extracting window dimensions
WINDOW_WIDTH=$(xdotool getwindowgeometry $WINDOW_ID | grep Geometry | awk '{print $2}' | cut -d'x' -f1)
WINDOW_HEIGHT=$(xdotool getwindowgeometry $WINDOW_ID | grep Geometry | awk '{print $2}' | cut -d'x' -f2)

# Calculate the center of the Chromium window
center_x=$((X_POS + WINDOW_WIDTH / 2))
center_y=$((Y_POS + WINDOW_HEIGHT / 2))

# Get the end time (current time + 30 seconds)
end_time=$(($(date +%s) + 30))

range=200

while [[ $(date +%s) -lt $end_time ]]; do
    # Calculate random offsets from the center
    random_x=$((RANDOM % (range*2 + 1) - range))
    random_y=$((RANDOM % (range*2 + 1) - range))

    # Compute the final random coordinates near the center of the Chromium window
    x=$((center_x + random_x))
    y=$((center_y + random_y))

    # Ensure x and y are within the window's boundaries
    if (( x < X_POS )); then x=$X_POS; fi
    if (( x > (X_POS + WINDOW_WIDTH) )); then x=$((X_POS + WINDOW_WIDTH - 1)); fi
    if (( y < Y_POS )); then y=$Y_POS; fi
    if (( y > (Y_POS + WINDOW_HEIGHT) )); then y=$((Y_POS + WINDOW_HEIGHT - 1)); fi

    # Log the coordinates to the terminal
    echo "Moving mouse to: X=$x, Y=$y"

    # Move the mouse to the computed location
    xdotool mousemove $x $y

    sleep 1  # Adjust this if you want more or fewer moves within that 30 seconds.
done

# Log the end time and a message to the file
echo "Script finished at: $(date) and exited." >> $logfile
