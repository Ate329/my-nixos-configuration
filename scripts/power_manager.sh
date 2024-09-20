# !/bin/bash

HYPRIDLE_CONF="/home/ate329/.config/hypr/hypridle.conf"
HYPRIDLE_CONF_AC="/home/ate329/.config/hypr/hypridle-ac.conf"
HYPRIDLE_CONF_BATTERY="/home/ate329/.config/hypr/hypridle-battery.conf"

# Find the correct paths for commands
CP_CMD=$(command -v cp)
PKILL_CMD=$(command -v pkill)
HYPRIDLE_CMD=$(command -v hypridle)

if [ -z "$CP_CMD" ] || [ -z "$PKILL_CMD" ] || [ -z "$HYPRIDLE_CMD" ]; then
    echo "Error: One or more required commands (cp, pkill, hypridle) not found."
    exit 1
fi

check_power() {
    for supply in /sys/class/power_supply/*/status; do
        if [ -f "$supply" ]; then
            status=$(cat "$supply")
            if [ "$status" = "Discharging" ]; then
                return 1  # On battery
            elif [ "$status" = "Charging" ] || [ "$status" = "Full" ]; then
                return 0  # On AC power
            fi
        fi
    done
    # If we haven't returned yet, check if AC adapter is online
    for supply in /sys/class/power_supply/*/online; do
        if [ -f "$supply" ]; then
            online=$(cat "$supply")
            if [ "$online" = "1" ]; then
                return 0  # AC adapter is online
            fi
        fi
    done
    return 1  # Default to battery if we can't determine
}

update_config() {
    if [ $1 -eq 0 ]; then
        # On AC power
        sudo "$CP_CMD" "$HYPRIDLE_CONF_AC" "$HYPRIDLE_CONF"
        echo "Switched to AC power configuration at $(date)"
    else
        # On battery
        sudo "$CP_CMD" "$HYPRIDLE_CONF_BATTERY" "$HYPRIDLE_CONF"
        echo "Switched to battery power configuration at $(date)"
    fi

    # Restart Hypridle only when the state changes
    sudo "$PKILL_CMD" hypridle
    sudo "$HYPRIDLE_CMD" &
    echo "Restarted Hypridle at $(date)"
}

last_state=-1  # Initialize to an invalid state

while true; do
    if check_power; then
        current_state=0  # AC power
        echo "Detected AC power at $(date)"
    else
        current_state=1  # Battery power
        echo "Detected battery power at $(date)"
    fi

    if [ $current_state -ne $last_state ]; then
        update_config $current_state
        last_state=$current_state
    else
        echo "No change in power state at $(date)"
    fi

    sleep 10  # Check every 10 seconds
done
