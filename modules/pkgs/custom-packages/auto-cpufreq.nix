{ pkgs, ... }:
{
  # auto-cpufreq config
  programs.auto-cpufreq = {
    enable = true;
    settings = {
      charger = {
        governor = "performance";
        turbo = "always";
        energy_performance_preference = "performance";
        platform_profile = "performance";
      };
      battery = {
        governor = "powersave";
        turbo = "never";
        energy_performance_preference = "power";
        platform_profile = "low-power";
        enable_thresholds = "true";
        start_threshold = 45;
        stop_threshold = 90;
      };
    };
  };

  # Make auto-cpufreq service more resilient
  systemd.services.auto-cpufreq = {
    serviceConfig = {
      Restart = "always";
      RestartSec = "5s";
      KillMode = "process";
    };
  };

  # Create the udev rule
  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${pkgs.systemd}/bin/systemctl start restart-auto-cpufreq.service"
    SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${pkgs.systemd}/bin/systemctl start restart-auto-cpufreq.service"
  '';

  # Service for power change events
  systemd.services.restart-auto-cpufreq = {
    description = "Restart auto-cpufreq service on power state change";
    script = ''
      ${pkgs.systemd}/bin/systemctl restart auto-cpufreq.service
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

  # Watchdog service
  systemd.services.auto-cpufreq-watchdog = {
    description = "Watchdog for auto-cpufreq service";
    after = [ "auto-cpufreq.service" ];
    wantedBy = [ "multi-user.target" ];
    script = ''
      while true; do
        if ! systemctl is-active auto-cpufreq.service > /dev/null; then
          systemctl start auto-cpufreq.service
        fi
        sleep 10
      done
    '';
    serviceConfig = {
      Type = "simple";
      User = "root";
      Restart = "always";
      RestartSec = "5s";
    };
  };
}
