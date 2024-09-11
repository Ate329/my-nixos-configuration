#!/bin/bash

# Variables
enable_battery=false
battery_icon=""

# Check availability
for battery in /sys/class/power_supply/*BAT*; do
  if [[ -f "$battery/uevent" ]]; then
    enable_battery=true
    status=$(cat /sys/class/power_supply/*/status | head -1)
    if [[ $status == "Charging" ]]; then
      battery_icon="⚡(+)" # Lightning bolt for charging
    else
      capacity=$(cat /sys/class/power_supply/*/capacity | head -1)
      if [ $capacity -ge 90 ]; then
        battery_icon="󰁹 (-)" # Full battery
      elif [ $capacity -ge 60 ]; then
        battery_icon="󰂀 (-)" # 3/4 battery
      elif [ $capacity -ge 30 ]; then
        battery_icon="󰁾 (-)" # Half battery
      elif [ $capacity -ge 10 ]; then
        battery_icon="󰁻 (-)" # 1/4 battery
      else
        battery_icon="󰂎 (-)" # Empty battery
      fi
    fi
    break
  fi
done

# Output
if [[ $enable_battery == true ]]; then
  capacity=$(cat /sys/class/power_supply/*/capacity | head -1)
  echo "${battery_icon} ${capacity}%"
fi
