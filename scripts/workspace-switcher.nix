{ writeShellScriptBin, jq, hyprland }:

writeShellScriptBin "workspace-switcher" ''
  # Get the current monitor, workspace, and active window
  current_monitor=$(${hyprland}/bin/hyprctl monitors -j | ${jq}/bin/jq -r '.[] | select(.focused == true) | .name')
  current_workspace=$(${hyprland}/bin/hyprctl activewindow -j | ${jq}/bin/jq '.workspace.id')
  active_window=$(${hyprland}/bin/hyprctl activewindow -j | ${jq}/bin/jq -r '.address')

  # Function to get the other monitor
  get_other_monitor() {
    if [ "$current_monitor" = "eDP-1" ]; then
      echo "HDMI-A-1"
    else
      echo "eDP-1"
    fi
  }

  # Function to calculate next/previous workspace
  calculate_workspace() {
    local direction=$1
    local base=$2
    local max=$3

    if [ "$direction" = "left" ]; then
      if [ "$current_workspace" -eq "$base" ]; then
        echo "$max"
      else
        echo $((current_workspace - 1))
      fi
    elif [ "$direction" = "right" ]; then
      if [ "$current_workspace" -eq "$max" ]; then
        echo "$base"
      else
        echo $((current_workspace + 1))
      fi
    fi
  }

  # Function to switch workspaces or move window
  switch_workspace() {
    local direction=$1
    local move_window=$2
    local other_monitor=$(get_other_monitor)

    if [ "$move_window" = "true" ] && [ "$active_window" != "0x0" ]; then
      if ([ "$direction" = "left" ] && [ "$current_workspace" -eq 1 -o "$current_workspace" -eq 11 ]) || \
         ([ "$direction" = "right" ] && [ "$current_workspace" -eq 10 -o "$current_workspace" -eq 20 ]); then
        ${hyprland}/bin/hyprctl dispatch movewindow mon:$other_monitor
      else
        local target_workspace
        if [ "$current_monitor" = "eDP-1" ]; then
          target_workspace=$(calculate_workspace $direction 1 10)
        else
          target_workspace=$(calculate_workspace $direction 11 20)
        fi
        ${hyprland}/bin/hyprctl dispatch movetoworkspace $target_workspace
      fi
    else
      local target_workspace
      if [ "$current_monitor" = "eDP-1" ]; then
        target_workspace=$(calculate_workspace $direction 1 10)
      else
        target_workspace=$(calculate_workspace $direction 11 20)
      fi
      ${hyprland}/bin/hyprctl dispatch workspace $target_workspace
    fi
  }

  # Main logic
  if [ "$1" = "switch" ]; then
    switch_workspace "$2" "false"
  elif [ "$1" = "move" ]; then
    switch_workspace "$2" "true"
  else
    if [ "$current_monitor" = "eDP-1" ]; then
      target=$1
    elif [ "$current_monitor" = "HDMI-A-1" ]; then
      target=$((10 + $1))
    else
      target=$1
    fi

    ${hyprland}/bin/hyprctl dispatch workspace $target
  fi
''
