# Comprehensive power management for AMD Ryzen 7 7840HS
# This file centralizes all power management configurations to avoid duplication and conflicts

{ pkgs, ... }:
{
  # === Consolidated power management for AMD Ryzen 7 7840HS ===
  # The Phoenix architecture (7040 series) features:
  # - Zen 4 CPU cores up to 5.1GHz
  # - RDNA 3 integrated GPU (Radeon 780M)
  # - Improved power efficiency

  # NOTE: If you maintain kernel parameters in config.nix, you may need to comment out
  # the boot.kernelParams section in this file to avoid duplication. The parameters below
  # should ideally be part of your configuration, but they might already exist elsewhere.

  # === 1. auto-cpufreq configuration ===
  # Dynamic CPU frequency management based on system load and power state
  programs.auto-cpufreq = {
    enable = false; # Disabled in favor of TLP
    settings = {
      charger = {
        governor = "performance";
        turbo = "auto"; # Auto turbo boost for maximum performance on AC
        energy_performance_preference = "performance";
        platform_profile = "performance";
      };
      battery = {
        governor = "powersave"; # Use powersave for maximum power efficiency
        turbo = "never"; # Disable turbo boost on battery as requested
        energy_performance_preference = "balance-power"; # Balance between power and performance
        platform_profile = "low-power";
        enable_thresholds = "true";
        start_threshold = 40;
        stop_threshold = 85;
      };
    };
  };

  # Make auto-cpufreq service more resilient - Settings restored but service not active due to enable = false
  systemd.services.auto-cpufreq = {
    serviceConfig = {
      Restart = "always";
      RestartSec = "5s";
      KillMode = "process";
    };
  };

  # Create the auto-cpufreq udev rule - Restored, but restart target service won't run effectively
  services.udev.extraRules = ''
    # Auto-cpufreq power change rules
    SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${pkgs.systemd}/bin/systemctl start restart-auto-cpufreq.service"
    SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${pkgs.systemd}/bin/systemctl start restart-auto-cpufreq.service"

    # Ryzen power service rules
    SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", RUN+="${pkgs.systemd}/bin/systemctl start ryzen-power.service"
    SUBSYSTEM=="power_supply", ATTR{status}=="Charging", RUN+="${pkgs.systemd}/bin/systemctl start ryzen-power.service"
    SUBSYSTEM=="power_supply", ATTR{status}=="Full", RUN+="${pkgs.systemd}/bin/systemctl start ryzen-power.service"
  '';

  # Service for power change events - Restored but won't be triggered effectively
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

  # Watchdog service - Restored but target service won't run
  systemd.services.auto-cpufreq-watchdog = {
    enable = false; # Explicitly disable the watchdog as auto-cpufreq is disabled
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

  # === 2. TLP configuration ===
  # TLP provides comprehensive power management for all hardware components
  # These settings are specifically optimized for the Ryzen 7 7840HS Phoenix architecture
  services.tlp = {
    enable = true;
    settings = {
      # CPU settings
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave"; # Changed to powersave for maximum power efficiency
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance-power"; # Better balance between power and performance

      # AMD CPU specific settings - optimized for Ryzen 7 7840HS
      # Use performance profile on AC for maximum performance
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";
      CPU_BOOST_ON_AC = 1; # Enable boost on AC
      CPU_BOOST_ON_BAT = 0; # Disable boost on battery as requested

      # Phoenix-specific AMD CPU settings - balanced power saving on battery
      # Updated frequency ranges based on user preferences
      CPU_SCALING_MIN_FREQ_ON_AC = 1700000;
      CPU_SCALING_MAX_FREQ_ON_AC = 5100000;
      CPU_SCALING_MIN_FREQ_ON_BAT = 1600000;
      CPU_SCALING_MAX_FREQ_ON_BAT = 3800000;

      # Power saving for PCI Express Active State Power Management
      # Use default on AC for better performance
      PCIE_ASPM_ON_AC = "default";
      PCIE_ASPM_ON_BAT = "powersupersave";

      # AMD Radeon 780M GPU power management
      # Set to performance on AC
      RADEON_DPM_PERF_LEVEL_ON_AC = "auto";
      RADEON_DPM_PERF_LEVEL_ON_BAT = "low";
      RADEON_DPM_STATE_ON_AC = "performance";
      RADEON_DPM_STATE_ON_BAT = "battery";
      RADEON_POWER_PROFILE_ON_AC = "high";
      RADEON_POWER_PROFILE_ON_BAT = "low";

      # Battery charge thresholds (if supported by hardware)
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 85;

      # Disable Wake-on-LAN
      WOL_DISABLE = "Y";

      # Runtime Power Management for devices
      # Disabled to prevent Bluetooth disconnections while on AC power
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto"; # Changed to auto for more aggressive power saving while preserving device functionality
      RUNTIME_PM_DRIVER_BLACKLIST = "bluetooth usb_device"; # Prevent power management for Bluetooth devices

      # Disable autosuspend for USB devices with specific IDs or all Bluetooth-related devices
      # Use 'lsusb' to find your specific keyboard's ID and add it here
      USB_BLACKLIST = "bluetooth"; # Blacklist all Bluetooth devices from power management

      # Audio power saving
      SOUND_POWER_SAVE_ON_AC = 0;
      SOUND_POWER_SAVE_ON_BAT = 1;
      SOUND_POWER_SAVE_CONTROLLER = "Y";

      # USB autosuspend - disabled to prevent Bluetooth peripherals disconnection
      USB_AUTOSUSPEND = 0;
      USB_EXCLUDE_AUDIO = 1;
      USB_EXCLUDE_BTUSB = 1;
      USB_EXCLUDE_PHONE = 1;
      USB_EXCLUDE_PRINTER = 1; # Added to prevent printer connection issues

      # NVMe power savings (Phoenix systems often have NVMe storage)
      AHCI_RUNTIME_PM_ON_AC = "on";
      AHCI_RUNTIME_PM_ON_BAT = "auto";

      # WiFi power saving - maximum power saving on battery
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on"; # Enable maximum WiFi power saving
    };
  };

  # Disable power-profiles-daemon since we're using TLP
  services.power-profiles-daemon.enable = false;

  # === 3. Additional thermal and power management ===
  # Enable thermald for better thermal management
  services.thermald.enable = false;

  # Enable UPower for better battery management
  services.upower = {
    enable = true;
    percentageLow = 15;
    percentageCritical = 5;
    percentageAction = 3;
    criticalPowerAction = "Hibernate";
  };

  # PowerManagement settings
  powerManagement = {
    enable = true; # Keep basic suspend/hibernate enabled
    powertop.enable = false; # Disabled, TLP handles tunables
  };

  # === 4. ryzenadj service for hardware-level control ===
  # AMD-specific tool that allows direct control of CPU power parameters
  # These values are tuned specifically for the Ryzen 7 7840HS
  # STAPM = Skin Temperature Aware Power Management
  # Fast Limit = Short-term power limit
  # Slow Limit = Long-term power limit
  systemd.services.ryzen-power = {
    description = "Optimize power settings for AMD Ryzen 7 7840HS";
    path = [
      pkgs.bash
      pkgs.ryzenadj
      pkgs.coreutils
      pkgs.gnugrep
    ];
    script = ''
      #!/bin/bash
      set -euo pipefail # Add error checking

      # Function to safely set CPU frequency limits - REMOVED as TLP handles this
      # set_cpu_freq() { ... }

      # Check if ryzenadj exists and is executable
      if ! command -v ryzenadj >/dev/null 2>&1; then
        echo "Error: ryzenadj not found or not executable"
        exit 1
      fi

      # Determine power state
      on_battery=0
      # Use a more robust way to check power status if possible, this is a basic check
      if grep -q "Discharging" /sys/class/power_supply/*/status 2>/dev/null; then
        on_battery=1
        echo "ryzen-power: Running on battery power"
      else
        echo "ryzen-power: Running on AC power"
      fi

      if [ $on_battery -eq 1 ]; then
        # On battery - apply ryzenadj limits only
        echo "ryzen-power: Applying battery ryzenadj limits."
        ryzenadj --stapm-limit=18000 --fast-limit=25000 --slow-limit=18000 --tctl-temp=90 --vrmmax-current=55000 --power-saving || echo "Warning: ryzenadj command failed for battery settings"

      else
        # On AC - apply ryzenadj limits only
        echo "ryzen-power: Applying AC ryzenadj limits."
        ryzenadj --stapm-limit=60000 --fast-limit=75000 --slow-limit=60000 --tctl-temp=95 --vrmmax-current=150000 || echo "Warning: ryzenadj command failed for AC settings"
      fi

      echo "ryzen-power: Ryzenadj settings applied successfully"
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "no";
    };
    wantedBy = [ "multi-user.target" ];
  };

  # Run the ryzen-power service periodically and on power state changes
  systemd.timers.ryzen-power = {
    description = "Timer for AMD Ryzen power optimization service";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "30s";
      OnUnitActiveSec = "5min";
    };
  };

  # Ensure ryzenadj is available
  environment.systemPackages = with pkgs; [ ryzenadj ];
}
