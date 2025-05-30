''
  # Updated window rules using the new windowrulev2 syntax for Hyprland
  windowrulev2 = pseudo, class:fcitx
  windowrulev2 = pseudo, class:fcitx5

  # Basic window rules for common applications
  windowrulev2 = noborder, class:rofi
  windowrulev2 = center, class:rofi
  # windowrulev2 = center, class:steam
  windowrulev2 = center, class:discord
  windowrulev2 = center, class:swappy
  windowrulev2 = center, class:vscode
  windowrulev2 = center, class:obsidian
  windowrulev2 = center, class:thunar
  windowrulev2 = center, class:gimp
  windowrulev2 = center, class:libreoffice
  windowrulev2 = center, class:soffice
  windowrulev2 = maximize, class:logisim-evolution
  windowrulev2 = center, class:logisim-evolution

  # Window rules for wine applications
  windowrulev2 = center, title:.*Wine.*
  windowrulev2 = float, title:.*Wine.*

  # LibreOffice specific rules
  windowrulev2 = center, class:LibreOffice
  windowrulev2 = center, title:.*LibreOffice.*
  windowrulev2 = center, title:.*Start Center.*

  # WeChat/微信 rules
  windowrulev2 = center, title:.*WeChat.*|.*微信.*
  windowrulev2 = nearestneighbor, title:.*WeChat.*|.*微信.*

  # Steam specific rules
  #windowrulev2 = stayfocused, title:^$,class:steam
  #windowrulev2 = minsize 1 1, title:^$,class:steam

  # Dialog window rules
  windowrulev2 = float, title:Open File.*
  windowrulev2 = float, title:Select a File.*
  windowrulev2 = float, title:Open Folder.*
  windowrulev2 = float, title:Save As.*
  windowrulev2 = float, title:Library.*
''
