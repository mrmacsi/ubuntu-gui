#!/bin/bash

# Log file path
logfile="/home/macit/log.txt"

if [ ! -f "$logfile" ]; then
    touch "$logfile"
fi

# Log the start time to the file
echo "Script started at: $(date)" >> $logfile

export DISPLAY=:20

# Get the end time (current time + 1 minute)
end_time=$(($(date +%s) + 30))

while [[ $(date +%s) -lt $end_time ]]; do
    # Get screen width and height
    screen_width=$(xdotool getdisplaygeometry | awk '{print $1}')
    screen_height=$(xdotool getdisplaygeometry | awk '{print $2}')

    # Calculate the center of the screen
    center_x=$((screen_width / 2))
    center_y=$((screen_height / 2))

    # Define a range for randomness, e.g., 300 pixels in any direction
    range=300

    # Calculate random offsets from the center
    random_x=$((RANDOM % (range*2 + 1) - range))
    random_y=$((RANDOM % (range*2 + 1) - range))

    # Compute the final random coordinates near the center
    x=$((center_x + random_x))
    y=$((center_y + random_y))

    # Log the coordinates to the terminal
    echo "Moving mouse to: X=$x, Y=$y"

    # Move the mouse to the computed location
    xdotool mousemove $x $y

    sleep 1  # You can adjust this if you want more or fewer moves within that 1 minute.
done

# Log the end time and a message to the file
echo "Script finished at: $(date) and exited." >> $logfile
