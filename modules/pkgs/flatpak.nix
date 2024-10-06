{ lib, pkgs, ... }:

let
  flatpakPackages = [
    # Add packages here
    "org.blender.Blender"
  ];
in
{
  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  system.activationScripts.flatpak-setup = {
    text = ''
      # Function to log messages
      log_message() {
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> /tmp/flatpak-setup.log
      }

      # Redirect errors to log file
      exec 2>> /tmp/flatpak-setup.log

      log_message "Starting Flatpak setup script"

      # Ensure Flathub repository is added (silent operation)
      ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo &>> /tmp/flatpak-setup.log

      # Update repository information (silent operation)
      ${pkgs.flatpak}/bin/flatpak update --appstream --noninteractive &>> /tmp/flatpak-setup.log

      # Install or update specified packages (showing progress)
      for pkg in ${lib.concatStringsSep " " flatpakPackages}; do
        echo "Installing/Updating Flatpak package: $pkg"
        ${pkgs.flatpak}/bin/flatpak install --or-update -y flathub $pkg
        echo "Finished processing $pkg"
      done

      # Remove packages not in the list (showing removal)
      for pkg in $(${pkgs.flatpak}/bin/flatpak list --app --columns=application); do
        if ! echo "${lib.concatStringsSep " " flatpakPackages}" | grep -q "$pkg"; then
          echo "Removing Flatpak package: $pkg"
          ${pkgs.flatpak}/bin/flatpak uninstall -y $pkg
          echo "Finished removing $pkg"
        fi
      done

      log_message "Flatpak setup completed"
      echo "Flatpak setup completed. Full log available in /tmp/flatpak-setup.log"
    '';
    deps = [];
  };
}
