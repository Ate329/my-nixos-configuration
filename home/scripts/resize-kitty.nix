{ pkgs }:

pkgs.writeShellScriptBin "kitty-zenith-resize" ''
  # Get the screen resolution
  resolution=$(${pkgs.xorg.xrandr}/bin/xrandr --current | grep '*' | uniq | awk '{print $1}')
  width=$(echo $resolution | cut -d 'x' -f1)
  height=$(echo $resolution | cut -d 'x' -f2)

  # Calculate 70% of the resolution
  width=$((width * 7 / 10))
  height=$((height * 7 / 10))

  # Launch kitty with calculated dimensions
  ${pkgs.kitty}/bin/kitty --start-as=fullscreen --override "initial_window_width=$width" --override "initial_window_height=$height" zenith
''
