	{
  pkgs,
  config,
  lib,
  inputs,
  username,
  host,
  ...
}:

let
  theme = config.colorScheme.palette;
  hyprplugins = inputs.hyprland-plugins.packages.${pkgs.system};
  inherit (import ../hosts/${host}/variables.nix)
    browser
    borderAnim
    terminal
    extraMonitorSettings
    ;
in
with lib;
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    plugins = [
      # hyprplugins.hyprtrails
    ];
    extraConfig =
      let
        modifier = "SUPER";
      in
      concatStrings [
        ''
                exec-once = dbus-update-activation-environment --systemd --all
                exec-once = systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
                # exec-once=swaybg -i /home/ate329/Pictures/Wallpapers/richard-horvath-_nWaeTF6qo0-unsplash.png -m fill
		# exec-once = killall -q hyprpaper;sleep .5 && hyprpaper
		exec-once = killall -q swww;sleep .5 && swww init
                exec-once = killall -q waybar;sleep .5 && waybar
                exec-once = killall -q swaync;sleep .5 && swaync
                exec-once = nm-applet --indicator
                exec-once = lxqt-policykit-agent
		exec-once = wl-paste --watch cliphist store
		exec-once = swww img /home/ate329/Pictures/Wallpapers/azusa_flower_crop.gif
                # exec-once = swww img /home/${username}/Pictures/Wallpapers/test.jpg
                monitor=,preferred,auto,1.8
                ${extraMonitorSettings}

                general {
                  gaps_in = 6
                  gaps_out = 8
                  border_size = 2
                  col.active_border = rgba(${theme.base0C}ff) rgba(${theme.base0D}ff) rgba(${theme.base0B}ff) rgba(${theme.base0E}ff) 45deg
                  col.inactive_border = rgba(${theme.base00}cc) rgba(${theme.base01}cc) 45deg
                  layout = dwindle
                  resize_on_border = true
                }

                input {
                  kb_layout = us
          	      kb_options = grp:alt_shift_toggle
                  #kb_options=caps:super
                  follow_mouse = 1
                  touchpad {
                    natural_scroll = false
                  }
                  sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
                  accel_profile = adaptive
                }

                env = NIXOS_OZONE_WL, 1
                env = NIXPKGS_ALLOW_UNFREE, 1
                env = XDG_CURRENT_DESKTOP, Hyprland
                env = XDG_SESSION_TYPE, wayland
                env = XDG_SESSION_DESKTOP, Hyprland
                env = GDK_BACKEND, wayland
                env = CLUTTER_BACKEND, wayland
                env = QT_QPA_PLATFORM, wayland
                env = QT_WAYLAND_DISABLE_WINDOWDECORATION, 1
                env = QT_AUTO_SCREEN_SCALE_FACTOR, 1
                env = SDL_VIDEODRIVER, x11
                env = MOZ_ENABLE_WAYLAND, 1
                windowrule = noborder,^(rofi)$
                windowrule = center,^(rofi)$
                windowrule = center,^(steam)$
		windowrule = center,^(discord)$
		windowrule = center,^(swappy)$
		windowrule = center,^(vscode)$
		windowrule = center,^(vscode-fhs)$
		windowrule = center,^(obsidian)$
		windowrule = center,^(thunar)$
		windowrule = center, floating:1		
                windowrulev2 = stayfocused, title:^()$,class:^(steam)$
                windowrulev2 = minsize 1 1, title:^()$,class:^(steam)$
		# Dialogs
		windowrule=float,title:^(Open File)(.*)$
		windowrule=float,title:^(Select a File)(.*)$
		windowrule=float,title:^(Open Folder)(.*)$
		windowrule=float,title:^(Save As)(.*)$
		windowrule=float,title:^(Library)(.*)$

		gestures {
                  workspace_swipe = true
                  workspace_swipe_fingers = 3
                }
                
		misc {
                  mouse_move_enables_dpms = true
                  key_press_enables_dpms = false
		  disable_hyprland_logo = true
		  force_default_wallpaper = 1
		  initial_workspace_tracking = 2
                }

                animations {
                  enabled = yes
                  bezier = wind, 0.05, 0.9, 0.1, 1.05
                  bezier = winIn, 0.1, 1.1, 0.1, 1.1
                  bezier = winOut, 0.3, -0.3, 0, 1
                  bezier = liner, 1, 1, 1, 1
                  animation = windows, 1, 6, wind, slide
                  animation = windowsIn, 1, 6, winIn, slide
                  animation = windowsOut, 1, 5, winOut, slide
                  animation = windowsMove, 1, 5, wind, slide
                  animation = border, 1, 1, liner
                  ${
                    if borderAnim == true then
                      ''
                        animation = borderangle, 1, 30, liner, loop
                      ''
                    else
                      ''''
                  }
                  animation = fade, 1, 10, default
                  animation = workspaces, 1, 5, wind
                }

                decoration {
                  rounding = 10
                  drop_shadow = false
                  blur {
                      enabled = true
                      size = 5
                      passes = 3
                      new_optimizations = on
                      ignore_opacity = on
                  }
                }

		xwayland {
		  use_nearest_neighbor = false
		}

                plugin {
                  hyprtrails {
                    color = rgba(${theme.base0A}ff)
                  }
                }

                dwindle {
                  pseudotile = true
                  preserve_split = true
                }

                master {
                  new_is_master = true
                }

                bind = ${modifier},Q,exec,${terminal}
                # bind = ${modifier}SHIFT,Return,exec,wofi
                bind = ${modifier}SHIFT,Return,exec,rofi-launcher
		bind = ${modifier},L,exec,wlogout
		bind = ${modifier}SHIFT,W,exec,web-search
                bind = ${modifier}ALT,W,exec,wallsetter
                bind = ${modifier}SHIFT,N,exec,swaync-client -rs
                bind = ${modifier},W,exec,${browser}
                bind = ${modifier}SHIFT,E,exec,emopicker9000
                bind = ${modifier}SHIFT,S,exec,grim -g "$(slurp)" - | wl-copy
                bindl = ,Print,exec,grim - | wl-copy
		bind = ${modifier},D,exec,discord
                bind = ${modifier},O,exec,obs
                bind = ${modifier},G,exec,gimp
                bind = ${modifier}SHIFT,G,exec,godot4
                bind = ${modifier},T,exec,thunar
                bind = ${modifier},M,exec,spotify
                bind = ${modifier},E,killactive,
                bind = ${modifier},P,pseudo,
                bind = ${modifier}SHIFT,I,togglesplit,
                bind = ${modifier},F,fullscreen,
                bind = ${modifier}SHIFT,F,togglefloating,
                bind = ${modifier}SHIFT,C,exit,
                bind = ${modifier}SHIFT,left,movewindow,l
                bind = ${modifier}SHIFT,right,movewindow,r
                bind = ${modifier}SHIFT,up,movewindow,u
                bind = ${modifier}SHIFT,down,movewindow,d
                bind = ${modifier}SHIFT,h,movewindow,l
                bind = ${modifier}SHIFT,l,movewindow,r
                bind = ${modifier}SHIFT,k,movewindow,u
                bind = ${modifier}SHIFT,j,movewindow,d
                bind = ${modifier},left,movefocus,l
                bind = ${modifier},right,movefocus,r
                bind = ${modifier},up,movefocus,u
                bind = ${modifier},down,movefocus,d
                #bind = ${modifier},h,movefocus,l
                #bind = ${modifier},l,movefocus,r
                #bind = ${modifier},k,movefocus,u
                #bind = ${modifier},j,movefocus,d
                bind = ${modifier},1,workspace,1
                bind = ${modifier},2,workspace,2
                bind = ${modifier},3,workspace,3
                bind = ${modifier},4,workspace,4
                bind = ${modifier},5,workspace,5
                bind = ${modifier},6,workspace,6
                bind = ${modifier},7,workspace,7
                bind = ${modifier},8,workspace,8
                bind = ${modifier},9,workspace,9
                bind = ${modifier},0,workspace,10
                bind = ${modifier}SHIFT,SPACE,movetoworkspace,special
                bind = ${modifier},SPACE,togglespecialworkspace
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
		bind = Control+Super+Shift,Right,movetoworkspace,+1
		bind = Control+Super+Shift,Left,movetoworkspace,-1
                bind = ${modifier}CONTROL,right,workspace,e+1
                bind = ${modifier}CONTROL,left,workspace,e-1
                bind = ${modifier},mouse_down,workspace,e+1
                bind = ${modifier},mouse_up,workspace,e-1
                bindm = ${modifier},mouse:272,movewindow
                bindm = ${modifier},mouse:273,resizewindow
                bind = ALT,Tab,cyclenext
                bind = ALT,Tab,bringactivetotop
                bind = ,XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
                bind = ,XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
                binde = ,XF86AudioMute,exec,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
                bind = ,XF86AudioPlay,exec,playerctl play-pause
                bind = ,XF86AudioPause,exec,playerctl play-pause
                bind = ,XF86AudioNext,exec,playerctl next
                bind = ,XF86AudioPrev,exec,playerctl previous
                bind = ,XF86MonBrightnessDown,exec,brightnessctl set 2%-
                bind = ,XF86MonBrightnessUp,exec,brightnessctl set +2%
                binde = ${modifier},Semicolon,splitratio,-0.1
		binde = ${modifier},Apostrophe,splitratio,0.1
		bind = ${modifier},V,exec,cliphist list | rofi -dmenu | cliphist decode | wl-copy
		# Text-to-image
		# Normal
		bind = Control+Super+Shift,S,exec,grim -g "$(slurp $SLURP_ARGS)" "tmp.png" && tesseract "tmp.png" - | wl-copy && rm "tmp.png"
		# English
		bind = Super+Shift,T,exec,grim -g "$(slurp $SLURP_ARGS)" "tmp.png" && tesseract -l eng "tmp.png" - | wl-copy && rm "tmp.png"
		# Japanese
		bind = Super+Shift,J,exec,grim -g "$(slurp $SLURP_ARGS)" "tmp.png" && tesseract -l jpn "tmp.png" - | wl-copy && rm "tmp.png"
        ''
      ];
  };
}
