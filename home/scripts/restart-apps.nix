{ pkgs }:

let
  task-waybar = pkgs.writeShellScriptBin "task-waybar" ''
    sleep 0.1
    ${pkgs.swaynotificationcenter}/bin/swaync-client -t &
  '';

  restart-apps = pkgs.writeShellScriptBin "restart-apps" ''
    if ! pgrep -x waybar > /dev/null; then
      killall -q waybar || true
      sleep 1
      ${pkgs.waybar}/bin/waybar &
    fi

    if ! pgrep -x swaync > /dev/null; then
      killall -q swaync || true
      sleep 0.9
      ${pkgs.swaynotificationcenter}/bin/swaync &
    fi
  '';
in
{
  environment.systemPackages = [ task-waybar restart-apps ];
}
