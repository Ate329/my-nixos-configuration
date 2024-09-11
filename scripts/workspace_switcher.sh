# !/bin/bash

current_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')
current_workspace=$(hyprctl activewindow -j | jq '.workspace.id')

if [ "$current_monitor" == "eDP-1" ]; then
    target=$1
elif [ "$current_monitor" == "HDMI-A-1" ]; then
    target=$((10 + $1))
else
    target=$1
fi

hyprctl dispatch workspace $target
