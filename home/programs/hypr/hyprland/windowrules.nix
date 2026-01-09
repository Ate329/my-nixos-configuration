''
  # Updated window rules using the new usage for Hyprland
  windowrule = pseudo on, match:class fcitx
  windowrule = pseudo on, match:class fcitx5

  # Basic window rules for common applications
  windowrule = border_size 0, match:class rofi
  windowrule = center on, match:class rofi
  # windowrule = center, match:class steam
  windowrule = center on, match:class discord
  windowrule = center on, match:class swappy
  windowrule = center on, match:class vscode
  windowrule = center on, match:class obsidian
  windowrule = center on, match:class thunar
  windowrule = center on, match:class gimp
  windowrule = center on, match:class libreoffice
  windowrule = center on, match:class soffice
  windowrule = maximize on, match:class logisim-evolution
  windowrule = center on, match:class logisim-evolution

  # Window rules for wine applications
  windowrule = center on, match:title .*Wine.*
  windowrule = float on, match:title .*Wine.*

  # LibreOffice specific rules
  windowrule = center on, match:class LibreOffice
  windowrule = center on, match:title .*LibreOffice.*
  windowrule = center on, match:title .*Start Center.*

  # WeChat/微信 rules
  windowrule = center on, match:title .*WeChat.*|.*微信.*
  # windowrule = nearestneighbor on, match:title .*WeChat.*|.*微信.*

  # Steam specific rules
  #windowrule = stayfocused on, match:title ^$, match:class steam
  #windowrule = minsize 1 1, match:title ^$, match:class steam

  # Dialog window rules
  windowrule = float on, match:title Open File.*
  windowrule = float on, match:title Select a File.*
  windowrule = float on, match:title Open Folder.*
  windowrule = float on, match:title Save As.*
  windowrule = float on, match:title Library.*
''
