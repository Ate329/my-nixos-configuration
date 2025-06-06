{
  pkgs,
  lib,
  username,
  colors,
  borderAnim,
  extraMonitorSettings,
}:

''
  # Start-up apps
  exec-once = dbus-update-activation-environment --systemd --all
  exec-once = systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
  exec-once = sleep 1 && nm-applet --indicator
  exec-once = sleep 1 && lxqt-policykit-agent
  exec-once = sleep 1 && wl-paste --watch cliphist store
  exec-once = sleep 1 && hypridle
  exec-once = sleep 1 && fcitx5 -d -r
  exec-once = sleep 1 && fcitx5-remote -r
  exec-once = sleep 2 && flatpak run app.zen_browser.zen
  exec-once = sleep 1 && restart-apps
  exec-once = sleep 1 && hyprctl setcursor Bibata-Modern-Ice 24
  exec-once = sleep 1 && hyprswitch init --show-title &
  exec = waypaper --restore

  # Environment
  env = NIXOS_OZONE_WL, 1
  env = LIBVA_DRIVER_NAME, radeonsi # For amd VA-API
  env = NIXPKGS_ALLOW_UNFREE, 1
  env = XDG_CURRENT_DESKTOP, Hyprland
  env = XDG_SESSION_TYPE, wayland
  env = XDG_SESSION_DESKTOP, Hyprland
  env = GDK_BACKEND, wayland,x11,*
  env = GDK_SCALE, 2
  env = XCURSOR_SIZE, 24
  env = CLUTTER_BACKEND, wayland
  env = QT_QPA_PLATFORM, wayland;xcb
  env = QT_WAYLAND_DISABLE_WINDOWDECORATION, 1
  env = QT_AUTO_SCREEN_SCALE_FACTOR, 1
  env = SDL_VIDEODRIVER, wayland,x11
  env = MOZ_ENABLE_WAYLAND, 1
  env = HYPRCURSOR_THEME, Bibata-Modern-Ice
  env = HYPRCURSOR_SIZE, 24
  env = AQ_NO_MODIFIERS, 1 # For systems with limitation (iGPU)

  # Monitor configuration
  monitor = eDP-1, preferred, auto, auto
  monitor = HDMI-A-1, preferred, auto-left, auto
  ${extraMonitorSettings}

  # General configuration
  general {
    gaps_in = 6
    gaps_out = 6
    border_size = 2
    col.active_border = rgba(${colors.base0C}ff) rgba(${colors.base0D}ff) rgba(${colors.base0B}ff) rgba(${colors.base0E}ff) 45deg
    col.inactive_border = rgba(${colors.base00}cc) rgba(${colors.base01}cc) 45deg
    layout = dwindle
    resize_on_border = true
  }

  # Input configuration
  input {
    kb_layout = us
    kb_options = grp:alt_shift_toggle
    follow_mouse = 1

    touchpad {
      drag_lock = true
      natural_scroll = false
      disable_while_typing = true
      scroll_factor = 0.6
    }

    sensitivity = 0
    accel_profile = flat
  }

  # Decoration
  decoration {
    rounding = 10
    shadow {
      enabled = false
      render_power = 2
      scale = 0.1
    }
    blur {
      enabled = true
      size = 5
      passes = 3
      new_optimizations = on
      ignore_opacity = on
    }
  }

  # Animations
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
    ${if borderAnim then "animation = borderangle, 1, 30, liner, loop" else ""}
    animation = fade, 1, 10, default
    animation = workspaces, 1, 5, wind
  }

  # Gestures
  gestures {
    workspace_swipe = true
    workspace_swipe_fingers = 3
    workspace_swipe_invert = false
    workspace_swipe_min_speed_to_force = 25
    workspace_swipe_forever = true
    workspace_swipe_direction_lock_threshold = 5
    workspace_swipe_distance = 350
  }

  # Misc
  misc {
    mouse_move_enables_dpms = true
    key_press_enables_dpms = true
    disable_hyprland_logo = true
    force_default_wallpaper = 1
    background_color = 0xf1eaff
    initial_workspace_tracking = 2
    animate_manual_resizes = true
    vfr = true
  }

  # Cursor
  cursor {
    sync_gsettings_theme = true
    inactive_timeout = 15
    enable_hyprcursor = true
  }

  # Workspaces
  workspace = 1, monitor:eDP-1
  workspace = 2, monitor:eDP-1
  workspace = 3, monitor:eDP-1
  workspace = 4, monitor:eDP-1
  workspace = 5, monitor:eDP-1
  workspace = 6, monitor:eDP-1
  workspace = 7, monitor:eDP-1
  workspace = 8, monitor:eDP-1
  workspace = 9, monitor:eDP-1
  workspace = 10, monitor:eDP-1

  workspace = 11, monitor:HDMI-A-1
  workspace = 12, monitor:HDMI-A-1
  workspace = 13, monitor:HDMI-A-1
  workspace = 14, monitor:HDMI-A-1
  workspace = 15, monitor:HDMI-A-1
  workspace = 16, monitor:HDMI-A-1
  workspace = 17, monitor:HDMI-A-1
  workspace = 18, monitor:HDMI-A-1
  workspace = 19, monitor:HDMI-A-1
  workspace = 20, monitor:HDMI-A-1

  # XWayland
  xwayland {
    use_nearest_neighbor = false
    force_zero_scaling = true
  }

  # Plugins
  plugin {
    hyprtrails {
      color = rgba(${colors.base0A}ff)
    }

    #hyprexpo {
    #  columns = 3
    #  gap_size = 5
    #  bg_col = rgb(111111)
    #  workspace_method = first current # [center/first] [workspace] e.g. first 1 or center m+1

    #  enable_gesture = true # laptop touchpad
    #  gesture_fingers = 3  # 3 or 4
    #  gesture_distance = 300 # how far is the "max"
    #  gesture_positive = false # positive = swipe down. Negative = swipe up.
    #}

    # Hyprspace configuration
    #overview {
    #  # Layout settings
    #  #panelHeight = 40
    #  panelBorderWidth = 1
    #  workspaceMargin = 10
    #  workspaceBorderSize = 2
    #  centerAligned = true
    #  hideOverlayLayers = true
    #  hideTopLayers = true

    #  # Behavior settings
    #  autoDrag = true
    #  autoScroll = true
    #  exitOnClick = true
    #  switchOnDrop = true
    #  showNewWorkspace = true
    #  showEmptyWorkspace = false
    #}
  }
''
