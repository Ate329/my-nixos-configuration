{ config, pkgs, ... }:

let
  restart-script = pkgs.writeShellScriptBin "restart-apps" ''
    sleep 1

    if ! ${pkgs.procps}/bin/pgrep -x waybar > /dev/null; then
      ${pkgs.procps}/bin/killall -q waybar || true
      ${pkgs.waybar}/bin/waybar &
    fi

    if ! ${pkgs.procps}/bin/pgrep -x swaync > /dev/null; then
      ${pkgs.procps}/bin/killall -q swaync || true
      ${pkgs.swaynotificationcenter}/bin/swaync &
    fi
  '';
in
{
  environment.systemPackages = [ restart-script ];

  systemd.user.services.restart-apps = {
    description = "Restart Waybar and Swaync";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${restart-script}/bin/restart-apps";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}
