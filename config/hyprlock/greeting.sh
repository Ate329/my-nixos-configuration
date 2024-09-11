# !/bin/bash

# Get current hour
hour=$(date +%H)

# Set greeting based on time
if [ $hour -ge 5 ] && [ $hour -lt 12 ]; then
    greeting="Good morning"
elif [ $hour -ge 12 ] && [ $hour -lt 18 ]; then
    greeting="Good afternoon"
elif [ $hour -ge 18 ] && [ $hour -lt 22 ]; then
    greeting="Good evening"
elif [ $hour -ge 22 ] || [ $hour -lt 1 ]; then
    greeting="It's getting late"
else
    greeting="It's too late now, you should go to sleep"
fi

# Output greeting with Welcome
echo "Welcome! $greeting"
