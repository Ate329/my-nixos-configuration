{
  lib,
  pkgs,
  config,
  ...
}:

let
  flatpakPackages = [
    # Add flatpak packages here
    "org.blender.Blender"
    "net.ankiweb.Anki"
    "org.kde.isoimagewriter"
    "com.cassidyjames.clairvoyant"
    "com.github.cassidyjames.dippi"
    "com.github.unrud.VideoDownloader"
    "org.fedoraproject.MediaWriter"
    "org.onionshare.OnionShare"
    "org.kde.kdenlive"
  ];

  # Helper function to create a standard Flatpak command
  flatpakCommand = "${pkgs.flatpak}/bin/flatpak";

  cfg = config.services.flatpak;
in
{
  options.services.flatpak = with lib; {
    removeUnmanagedPackages = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to remove Flatpak packages not listed in 'packages'.";
    };

    removeUnmanagedRemotes = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to remove Flatpak remotes not listed in 'remotes'.";
    };

    packages = mkOption {
      type = types.listOf types.str;
      default = flatpakPackages;
      description = "List of Flatpak packages to install.";
    };

    remotes = mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            name = mkOption {
              type = types.str;
              description = "Name of the Flatpak remote.";
            };
            url = mkOption {
              type = types.str;
              description = "URL of the Flatpak remote.";
            };
          };
        }
      );
      default = [
        {
          name = "flathub";
          url = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        }
      ];
      description = "List of Flatpak remotes to add. By default, includes Flathub.";
    };

    update = {
      auto = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Whether to enable automatic updates for Flatpak packages.";
        };

        onCalendar = mkOption {
          type = types.nullOr types.str;
          default = "weekly";
          description = "When to run automatic updates, in systemd calendar format.";
        };
      };

      duringBuild = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to update Flatpak packages during system build.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Remove the circular dependency
    # services.flatpak.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    # Helper script to manage Flatpak packages declaratively
    system.extraSystemBuilderCmds =
      let
        manageFlatpaks = pkgs.writeShellScript "manage-flatpaks" ''
          set -eou pipefail

          # Log function
          log_message() {
            echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> /tmp/flatpak-setup.log
          }

          # Redirect errors to log file
          exec 2>> /tmp/flatpak-setup.log

          log_message "Starting Flatpak packages management"

          # Get list of configured packages
          configured_packages="${lib.concatStringsSep " " cfg.packages}"

          # Install or update specified packages
          for pkg in $configured_packages; do
            log_message "Processing package: $pkg"
            if ! ${flatpakCommand} info $pkg &> /dev/null; then
              echo "Installing Flatpak package: $pkg"
              ${flatpakCommand} install --noninteractive -y flathub $pkg
              echo "Finished installing $pkg"
            else
              log_message "Package $pkg is already installed"
              # Update the package if needed
              ${flatpakCommand} update --noninteractive -y $pkg || true
            fi
          done

          # Remove packages not in the list if removeUnmanagedPackages is enabled
          if [ "${toString cfg.removeUnmanagedPackages}" = "true" ]; then
            for pkg in $(${flatpakCommand} list --app --columns=application); do
              if ! echo "$configured_packages" | grep -q "$pkg"; then
                echo "Removing Flatpak package: $pkg"
                ${flatpakCommand} uninstall --noninteractive -y $pkg
                echo "Finished removing $pkg"
              fi
            done
          fi

          log_message "Flatpak package management completed"
          echo "Flatpak setup completed. Full log available in /tmp/flatpak-setup.log"
        '';
      in
      ''
        # This is a placeholder for system.extraSystemBuilderCmds
        echo "Flatpak management script prepared"
      '';

    # Activation script for installation and managing remotes
    system.activationScripts.flatpak-setup = ''
      set -eou pipefail

      # First completely remove and re-add flathub to ensure it works correctly
      if ${flatpakCommand} remotes | grep -q "^flathub"; then
        ${flatpakCommand} remote-delete --force flathub
      fi
      ${flatpakCommand} remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

      # Configure other remotes
      configured_remote_names=" flathub ${
        lib.concatStringsSep " " (lib.remove "flathub" (map (r: r.name) cfg.remotes))
      } "

      # Process non-flathub remotes
      ${lib.concatMapStrings (
        remote:
        lib.optionalString (remote.name != "flathub") ''
          if ! ${flatpakCommand} remotes | grep -q "^${remote.name}"; then
            ${flatpakCommand} remote-add --if-not-exists "${remote.name}" "${remote.url}"
          else
            ${flatpakCommand} remote-modify --url "${remote.url}" "${remote.name}"
          fi
        ''
      ) cfg.remotes}

      # Remove unconfigured remotes
      ${lib.optionalString cfg.removeUnmanagedRemotes ''
        for existing_remote in $(${flatpakCommand} remotes | cut -f1); do
          if [[ "$configured_remote_names" != *" $existing_remote "* ]]; then
            ${flatpakCommand} remote-delete --force "$existing_remote" || true
          fi
        done
      ''}

      # Update the repository data
      ${flatpakCommand} update --appstream >/dev/null 2>&1 || true

      # Process packages
      ${lib.concatMapStrings (pkg: ''
        if ! ${flatpakCommand} info ${pkg} &> /dev/null; then
          echo "Installing ${pkg}..."
          ${flatpakCommand} install --noninteractive -y flathub ${pkg} >/dev/null || true
        else
          ${flatpakCommand} update --noninteractive -y ${pkg} >/dev/null 2>&1 || true
        fi
      '') cfg.packages}

      # Remove unmanaged packages
      ${lib.optionalString cfg.removeUnmanagedPackages ''
        configured_packages="${lib.concatStringsSep " " cfg.packages}"
        for installed_pkg in $(${flatpakCommand} list --app --columns=application); do
          if ! echo "$configured_packages" | grep -q "$installed_pkg"; then
            echo "Removing $installed_pkg..."
            ${flatpakCommand} uninstall --noninteractive -y $installed_pkg >/dev/null || true
          fi
        done
      ''}
    '';

    # Systemd service for automatic updates
    systemd.services.flatpak-update = lib.mkIf cfg.update.auto.enable {
      description = "Flatpak package updates";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      path = [ pkgs.flatpak ];
      script = ''
        ${flatpakCommand} update --assumeyes
      '';
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };

    systemd.timers.flatpak-update =
      lib.mkIf (cfg.update.auto.enable && cfg.update.auto.onCalendar != null)
        {
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = cfg.update.auto.onCalendar;
            Persistent = true;
            Unit = "flatpak-update.service";
          };
        };
  };
}
