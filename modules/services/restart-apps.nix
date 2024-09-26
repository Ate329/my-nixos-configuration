{ config, pkgs, ... }:

let
  restart-script = pkgs.writeShellScriptBin "restart-apps" ''
    sleep 2

    # Function to start an application if it's not running
    start_app() {
      local app_name=$1
      local app_command=$2

      if ! ${pkgs.procps}/bin/pgrep -u $(id -u) -x "$app_name" > /dev/null; then
        # If the app isn't running, start it
        $app_command &
      fi
    }

    # Ensure no leftover instances before starting
    ${pkgs.psmisc}/bin/killall -q waybar swaync || true

    # Start apps in parallel
    start_app "waybar" "${pkgs.waybar}/bin/waybar" &
    start_app "swaync" "${pkgs.swaynotificationcenter}/bin/swaync" &

    # Wait for all background processes to finish
    wait
  '';
in
{
  environment.systemPackages = [ restart-script ];

  systemd.user.services.restart-apps = {
    description = "Restart Waybar and Swaync";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session-pre.target" "hyprland.service" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${restart-script}/bin/restart-apps";
      Restart = "on-failure";
      RestartSec = 5;
      ExecStartPre = "-${pkgs.psmisc}/bin/killall -q waybar swaync || true";
    };
  };
}
