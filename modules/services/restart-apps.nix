{ config, pkgs, ... }:

let
  restart-script = pkgs.writeShellScriptBin "restart-apps" ''
    monitor_and_restart() {
      app_name=$1
      binary_path=$2

      while true; do
        if ! ${pkgs.procps}/bin/pgrep -x "$app_name" > /dev/null; then
          echo "$(date): $app_name is not running. Attempting to start..."
          ${pkgs.procps}/bin/pkill -x "$app_name" || true
          $binary_path &

          # Wait and check if the app started successfully
          for i in {1..3}; do
            sleep 2
            if ${pkgs.procps}/bin/pgrep -x "$app_name" > /dev/null; then
              echo "$(date): $app_name started successfully"
              break
            fi
            if [ $i -eq 3 ]; then
              echo "$(date): Failed to start $app_name after attempts. Restarting..."
              ${pkgs.procps}/bin/pkill -x "$app_name" || true
              $binary_path &
            fi
          done
        else
          # Check if the app is responsive
          if ! ${pkgs.procps}/bin/pgrep -x "$app_name" > /dev/null; then
            echo "$(date): $app_name is unresponsive. Restarting..."
            ${pkgs.procps}/bin/pkill -x "$app_name" || true
            $binary_path &
          fi
        fi
        sleep 3
      done
    }

    monitor_and_restart "waybar" "${pkgs.waybar}/bin/waybar" &
    monitor_and_restart "swaync" "${pkgs.swaynotificationcenter}/bin/swaync" &

    wait
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
      Restart = "always";
      RestartSec = 3;
    };
  };
}
