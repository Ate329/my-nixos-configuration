#!/bin/bash

check_power() {
    # Check all power supplies
    for supply in /sys/class/power_supply/*/status; do
        if [ -f "$supply" ]; then
            status=$(cat "$supply")
            if [ "$status" = "Discharging" ]; then
                return 1  # On battery
            fi
        fi
    done
    return 0  # Not discharging, assumed to be on AC power
}

last_state=-1  # Initialize to an invalid state

while true; do
    if check_power; then
        current_state=0  # AC power
    else
        current_state=1  # Battery power
    fi

    if [ $current_state -ne $last_state ]; then
        if [ $current_state -eq 0 ]; then
            # On AC power
            hyprctl keyword exec-once "hypridle --ac-config"
            echo "Switched to AC power configuration"
        else
            # On battery
            hyprctl keyword exec-once "hypridle --battery-config"
            echo "Switched to battery power configuration"
        fi
        last_state=$current_state
    fi

    sleep 10  # Check every 10 seconds
done