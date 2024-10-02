{ pkgs, lib, username, terminal, browser, workspace-switcher }:

let
  modifier = "SUPER";
  left = "h";
  right = "l";
  up = "k";
  down = "j";
in
''
  # Application launchers
  bind = ${modifier},Q,exec,${terminal}
  bind = ${modifier}SHIFT,Return,exec,rofi-launcher
  bind = ${modifier},W,exec,${browser}
  bind = ${modifier},O,exec,obs
  bind = ${modifier},G,exec,gimp
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
  bind = ${modifier},1,exec,${workspace-switcher}/bin/workspace-switcher 1
  bind = ${modifier},2,exec,${workspace-switcher}/bin/workspace-switcher 2
  bind = ${modifier},3,exec,${workspace-switcher}/bin/workspace-switcher 3
  bind = ${modifier},4,exec,${workspace-switcher}/bin/workspace-switcher 4
  bind = ${modifier},5,exec,${workspace-switcher}/bin/workspace-switcher 5
  bind = ${modifier},6,exec,${workspace-switcher}/bin/workspace-switcher 6
  bind = ${modifier},7,exec,${workspace-switcher}/bin/workspace-switcher 7
  bind = ${modifier},8,exec,${workspace-switcher}/bin/workspace-switcher 8
  bind = ${modifier},9,exec,${workspace-switcher}/bin/workspace-switcher 9
  bind = ${modifier},0,exec,${workspace-switcher}/bin/workspace-switcher 10

  # Move window to workspace
  bind = ${modifier}SHIFT,1,movetoworkspace,1
  bind = ${modifier}SHIFT,2,movetoworkspace,2
  bind = ${modifier}SHIFT,3,movetoworkspace,3
  bind = ${modifier}SHIFT,4,movetoworkspace,4
  bind = ${modifier}SHIFT,5,movetoworkspace,5
  bind = ${modifier}SHIFT,6,movetoworkspace,6
  bind = ${modifier}SHIFT,7,movetoworkspace,7
  bind = ${modifier}SHIFT,8,movetoworkspace,8
  bind = ${modifier}SHIFT,9,movetoworkspace,9
  bind = ${modifier}SHIFT,0,movetoworkspace,10

  bind = ${modifier}ALT,1,movetoworkspace,11
  bind = ${modifier}ALT,2,movetoworkspace,12
  bind = ${modifier}ALT,3,movetoworkspace,13
  bind = ${modifier}ALT,4,movetoworkspace,14
  bind = ${modifier}ALT,5,movetoworkspace,15
  bind = ${modifier}ALT,6,movetoworkspace,16
  bind = ${modifier}ALT,7,movetoworkspace,17
  bind = ${modifier}ALT,8,movetoworkspace,18
  bind = ${modifier}ALT,9,movetoworkspace,19
  bind = ${modifier}ALT,0,movetoworkspace,20

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
  bind = ALT,TAB,hyprexpo:expo,toggle
  bind = ${modifier},TAB,exec,hyprctl dispatch overview:toggle
  bind = ${modifier}SHIFT,TAB,exec,hyprctl dispatch overview:toggle all
  bind = ${modifier},M,exec,kitty btop

  # Text-to-image functions
  bind = ${modifier}Control+Shift,S,exec,grim -g "$(slurp $SLURP_ARGS)" "tmp.png" && tesseract "tmp.png" - | wl-copy && rm "tmp.png"
  bind = ${modifier}Shift,T,exec,grim -g "$(slurp $SLURP_ARGS)" "tmp.png" && tesseract -l eng "tmp.png" - | wl-copy && rm "tmp.png"
  bind = ${modifier}Shift,J,exec,grim -g "$(slurp $SLURP_ARGS)" "tmp.png" && tesseract -l jpn "tmp.png" - | wl-copy && rm "tmp.png"

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
  # bind = ALT,Tab,cyclenext
  bind = ALT,Tab,bringactivetotop
''
