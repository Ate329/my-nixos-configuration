{ writeShellScriptBin, jq, hyprland }:

writeShellScriptBin "workspace-switcher" ''
  current_monitor=$(${hyprland}/bin/hyprctl monitors -j | ${jq}/bin/jq -r '.[] | select(.focused == true) | .name')
  current_workspace=$(${hyprland}/bin/hyprctl activewindow -j | ${jq}/bin/jq '.workspace.id')

  if [ "$current_monitor" == "eDP-1" ]; then
      target=$1
  elif [ "$current_monitor" == "HDMI-A-1" ]; then
      target=$((10 + $1))
  else
      target=$1
  fi

  ${hyprland}/bin/hyprctl dispatch workspace $target
''
