{ config, pkgs, ... }:

let
  restart-script = pkgs.writeShellScriptBin "restart-apps" ''
    sleep 5

    # Function to start an application if it's not running
    start_app() {
      local app_name=$1
      local app_command=$2

      if ! ${pkgs.procps}/bin/pgrep -x "$app_name" > /dev/null; then
        # If the app isn't running, start it
        $app_command &
        sleep 2
      fi
    }

    # Ensure no leftover instances before starting
    ${pkgs.psmisc}/bin/killall -q waybar swaync || true

    # Start Waybar
    start_app "waybar" "${pkgs.waybar}/bin/waybar"

    # Start Swaync
    start_app "swaync" "${pkgs.swaynotificationcenter}/bin/swaync"
  '';
in
{
  environment.systemPackages = [ restart-script ];

  systemd.user.services.restart-apps = {
    description = "Restart Waybar and Swaync";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session-pre.target" "hyprland.service" ]; # Ensures Hyprland is ready

    serviceConfig = {
      Type = "simple";
      ExecStart = "${restart-script}/bin/restart-apps";
      Restart = "on-failure";
      RestartSec = 5;
      ExecStartPre = "${pkgs.psmisc}/bin/killall -q waybar swaync || true"; # Clean up any old instances
    };
  };
}
