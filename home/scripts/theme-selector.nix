{ pkgs }:

pkgs.writeShellScriptBin "theme-selector" ''
      #!/usr/bin/env bash
      # Get user selection for new theme from base16-themes file
      chosen=$(cat $HOME/.base16-themes | ${pkgs.rofi}/bin/rofi -dmenu)

      # Exit if none chosen.
      if [ -z "$chosen" ]; then
        exit 0
      fi

      if [ -n "$1" ]; then
  	    themechange "$chosen"
      else
  	    ${pkgs.libnotify}/bin/notify-send "$chosen is building please wait" &
  	    themechange "$chosen"
  	    ${pkgs.libnotify}/bin/notify-send "Theme: $chosen has been applied." &
      fi
''
