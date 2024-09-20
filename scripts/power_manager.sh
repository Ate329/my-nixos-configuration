# !/bin/bash

HYPRIDLE_CONF="/home/$USER/.config/hypr/hypridle.conf"
HYPRIDLE_CONF_AC="/home/$USER/.config/hypr/hypridle-ac.conf"
HYPRIDLE_CONF_BATTERY="/home/$USER/.config/hypr/hypridle-battery.conf"

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
        cp "$HYPRIDLE_CONF_AC" "$HYPRIDLE_CONF"
        echo "Switched to AC power configuration at $(date)"
    else
        # On battery
        cp "$HYPRIDLE_CONF_BATTERY" "$HYPRIDLE_CONF"
        echo "Switched to battery power configuration at $(date)"
    fi

    # Restart Hypridle
    pkill hypridle
    hypridle &
    echo "Restarted Hypridle at $(date)"
}

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
