{ config, lib, pkgs, ... }:

let
  powerManagerScript = pkgs.writeShellScriptBin "power-manager" ''
    HYPRIDLE_CONF="/home/ate329/.config/hypr/hypridle.conf"
    HYPRIDLE_CONF_AC="/home/ate329/.config/hypr/hypridle-ac.conf"
    HYPRIDLE_CONF_BATTERY="/home/ate329/.config/hypr/hypridle-battery.conf"

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
            ${pkgs.coreutils}/bin/cp "$HYPRIDLE_CONF_AC" "$HYPRIDLE_CONF"
            echo "Switched to AC power configuration at $(date)"
        else
            # On battery
            ${pkgs.coreutils}/bin/cp "$HYPRIDLE_CONF_BATTERY" "$HYPRIDLE_CONF"
            echo "Switched to battery power configuration at $(date)"
        fi

        # Restart Hypridle only when the state changes
        ${pkgs.procps}/bin/pkill hypridle
        ${pkgs.hypridle}/bin/hypridle &
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
  '';
in
{
  systemd.services.power-manager = {
    description = "Power Manager for Hypridle";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${powerManagerScript}/bin/power-manager";
      Restart = "always";
      RestartSec = "10s";
      User = "root";  # The service needs root privileges to modify the config and restart hypridle
    };
  };
}
