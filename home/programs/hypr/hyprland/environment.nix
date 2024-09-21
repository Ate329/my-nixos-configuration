{ pkgs, config, lib, inputs, username, host, ... }:

''
  env = NIXOS_OZONE_WL, 1
  env = NIXPKGS_ALLOW_UNFREE, 1
  env = XDG_CURRENT_DESKTOP, Hyprland
  env = XDG_SESSION_TYPE, wayland
  env = XDG_SESSION_DESKTOP, Hyprland
  env = GDK_BACKEND, wayland
  env = GDK_SCALE, 2
  env = XCURSOR_SIZE,24
  env = CLUTTER_BACKEND, wayland
  env = QT_QPA_PLATFORM, wayland
  env = QT_WAYLAND_DISABLE_WINDOWDECORATION, 1
  env = QT_AUTO_SCREEN_SCALE_FACTOR, 1
  env = SDL_VIDEODRIVER, x11
  env = MOZ_ENABLE_WAYLAND, 1
''
