{ writeShellScriptBin, coreutils }:

let
  greeting-script = writeShellScriptBin "hyprlock-greeting" ''
    hour=$(${coreutils}/bin/date +%H)

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

    echo "Welcome! $greeting"
  '';

  status-script = writeShellScriptBin "hyprlock-status" ''
    enable_battery=false
    battery_icon=""

    for battery in /sys/class/power_supply/*BAT*; do
      if [[ -f "$battery/uevent" ]]; then
        enable_battery=true
        status=$(${coreutils}/bin/cat /sys/class/power_supply/*/status | ${coreutils}/bin/head -1)
        if [[ $status == "Charging" ]]; then
          battery_icon="⚡ (+)"
        else
          capacity=$(${coreutils}/bin/cat /sys/class/power_supply/*/capacity | ${coreutils}/bin/head -1)
          if [ $status == "Full" ]; then
            battery_icon="󰁹 (+)"
          elif [ $capacity -ge 90 ]; then
            battery_icon="󰁹 (-)"
          elif [ $capacity -ge 60 ]; then
            battery_icon="󰂀 (-)"
          elif [ $capacity -ge 30 ]; then
            battery_icon="󰁾 (-)"
          elif [ $capacity -ge 10 ]; then
            battery_icon="󰁻 (-)"
          else
            battery_icon="󰂎 (-)"
          fi
        fi
        break
      fi
    done

    if [[ $enable_battery == true ]]; then
      capacity=$(${coreutils}/bin/cat /sys/class/power_supply/*/capacity | ${coreutils}/bin/head -1)
      echo "''${battery_icon} ''${capacity}%"
    fi
  '';
in
{
  inherit greeting-script status-script;
}
