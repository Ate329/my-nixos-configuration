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
  inherit (config.lib.stylix) colors;
  hyprplugins = inputs.hyprland-plugins.packages.${pkgs.system};
  inherit (import ../../../../hosts/${host}/variables.nix)
    browser
    borderAnim
    terminal
    extraMonitorSettings
    ;

  workspace-switcher = pkgs.callPackage ../../../../home/scripts/workspace-switcher.nix {
    inherit (pkgs) writeShellScriptBin jq;
    hyprland = inputs.hyprland.packages.${pkgs.system}.default;
  };
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    plugins = [
      # hyprplugins.hyprtrails
      # hyprplugins.csgo-vulkan-fix
      # hyprplugins.hyprexpo
      # inputs.Hyprspace.packages.${pkgs.system}.Hyprspace
    ];
    extraConfig =
      (import ./config.nix {
        inherit
          pkgs
          lib
          username
          colors
          borderAnim
          extraMonitorSettings
          ;
      })
      + (import ./windowrules.nix)
      + (import ./binds.nix {
        inherit
          pkgs
          lib
          username
          terminal
          browser
          workspace-switcher
          ;
      });
  };
}
