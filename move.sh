#!/bin/bash

while true; do
    # Get screen width and height
    screen_width=$(xdotool getdisplaygeometry | awk '{print $1}')
    screen_height=$(xdotool getdisplaygeometry | awk '{print $2}')

    # Calculate the center of the screen
    center_x=$((screen_width / 2))
    center_y=$((screen_height / 2))

    # Define a range for randomness, e.g., 100 pixels in any direction
    range=100

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

    sleep 10  # Sleeps for 60 seconds (1 minute)
done
