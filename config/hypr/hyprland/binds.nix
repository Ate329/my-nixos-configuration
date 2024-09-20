{ pkgs, lib, username, terminal, browser, workspace-switcher }:

let
  modifier = "SUPER";
  left = "h";
  right = "l";
  up = "k";
  down = "j";
in
with lib;
''
  # Application launchers
  bind = ${modifier},Q,exec,${terminal}
  bind = ${modifier}SHIFT,Return,exec,rofi-launcher
  bind = ${modifier},W,exec,${browser}
  bind = ${modifier},D,exec,discord
  bind = ${modifier},O,exec,obs
  bind = ${modifier},G,exec,gimp
  bind = ${modifier}SHIFT,G,exec,godot4
  bind = ${modifier},T,exec,thunar
  bind = ${modifier},S,exec,spotify

  # System controls
  bind = ${modifier},L,exec,wlogout
  bind = ${modifier}SHIFT,C,exit,
  bind = ${modifier}SHIFT,N,exec,swaync-client -rs

  # Window management
  bind = ${modifier},E,killactive,
  bind = ${modifier},P,pseudo,
  bind = ${modifier}SHIFT,I,togglesplit,
  bind = ${modifier},F,fullscreen,
  bind = ${modifier}SHIFT,F,togglefloating,

  # Move focus with modifier + arrow keys
  bind = ${modifier},left,movefocus,l
  bind = ${modifier},right,movefocus,r
  bind = ${modifier},up,movefocus,u
  bind = ${modifier},down,movefocus,d

  # Move windows with modifier + shift + vim keys
  bind = ${modifier}SHIFT,${left},movewindow,l
  bind = ${modifier}SHIFT,${right},movewindow,r
  bind = ${modifier}SHIFT,${up},movewindow,u
  bind = ${modifier}SHIFT,${down},movewindow,d

  # Resize windows
  binde = ${modifier},Semicolon,splitratio,-0.1
  binde = ${modifier},Apostrophe,splitratio,0.1

  # Workspace management
  ${concatMapStrings (i: ''
    bind = ${modifier},${toString i},exec,${workspace-switcher}/bin/workspace-switcher ${toString i}
  '') (range 1 10)}

  # Move window to workspace
  ${concatMapStrings (i: ''
    bind = ${modifier}SHIFT,${toString i},movetoworkspace,${toString i}
  '') (range 1 10)}

  # Workspace navigation
  bind = ${modifier}CONTROL,left,exec,${workspace-switcher}/bin/workspace-switcher switch left
  bind = ${modifier}CONTROL,right,exec,${workspace-switcher}/bin/workspace-switcher switch right
  bind = ${modifier}CONTROL_SHIFT,left,exec,${workspace-switcher}/bin/workspace-switcher move left
  bind = ${modifier}CONTROL_SHIFT,right,exec,${workspace-switcher}/bin/workspace-switcher move right
  bind = ${modifier}SHIFT,Up,workspace,-10
  bind = ${modifier}SHIFT,Down,workspace,+10
  bind = ${modifier}CONTROL,Right,workspace,e+1
  bind = ${modifier}CONTROL,Left,workspace,e-1
  bind = ${modifier}SHIFT,left,workspace,-1
  bind = ${modifier}SHIFT,right,workspace,+1
  bind = ${modifier},mouse_down,workspace,e+1
  bind = ${modifier},mouse_up,workspace,e-1

  # Special workspace
  bind = ${modifier}SHIFT,SPACE,movetoworkspace,special
  bind = ${modifier},SPACE,togglespecialworkspace
  bind = ${modifier},M,moveworkspacetomonitor,1 current

  # Utility functions
  bind = ${modifier}SHIFT,W,exec,web-search
  bind = ${modifier}ALT,W,exec,wallsetter
  bind = ${modifier}SHIFT,E,exec,emopicker9000
  bind = ${modifier}SHIFT,S,exec,grim -g "$(slurp)" - | wl-copy
  bindl = ,Print,exec,grim - | wl-copy
  bind = ${modifier},V,exec,cliphist list | rofi -dmenu | cliphist decode | wl-copy

  # Text-to-image functions
  bind = Control+Super+Shift,S,exec,grim -g "$(slurp $SLURP_ARGS)" "tmp.png" && tesseract "tmp.png" - | wl-copy && rm "tmp.png"
  bind = Super+Shift,T,exec,grim -g "$(slurp $SLURP_ARGS)" "tmp.png" && tesseract -l eng "tmp.png" - | wl-copy && rm "tmp.png"
  bind = Super+Shift,J,exec,grim -g "$(slurp $SLURP_ARGS)" "tmp.png" && tesseract -l jpn "tmp.png" - | wl-copy && rm "tmp.png"

  # Multimedia keys
  bind = ,XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
  bind = ,XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
  binde = ,XF86AudioMute,exec,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
  bind = ,XF86AudioPlay,exec,playerctl play-pause
  bind = ,XF86AudioPause,exec,playerctl play-pause
  bind = ,XF86AudioNext,exec,playerctl next
  bind = ,XF86AudioPrev,exec,playerctl previous
  bind = ,XF86MonBrightnessDown,exec,brightnessctl set 2%-
  bind = ,XF86MonBrightnessUp,exec,brightnessctl set +2%

  # Mouse bindings
  bindm = ${modifier},mouse:272,movewindow
  bindm = ${modifier},mouse:273,resizewindow

  # Other
  bind = ALT,Tab,cyclenext
  bind = ALT,Tab,bringactivetotop
''
