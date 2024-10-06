{ lib, pkgs, ... }:

let
  # Define the list of Flatpak packages
  flatpakPackages = [
    # Add or remove packages here
    "org.blender.Blender"
  ];
in
{
  services.flatpak = {
    enable = true;
    package = pkgs.flatpak;
  };

  # Enable Flatpak support in NixOS
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Use system.activationScripts to manage Flatpak repository and packages
  system.activationScripts.flatpak-setup = {
    text = ''
      set -e  # Exit immediately if a command exits with a non-zero status
      exec &> >(tee -a /tmp/flatpak-setup.log)  # Redirect output to a log file

      echo "Starting Flatpak setup script"

      echo "Adding Flathub repository"
      ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || { echo "Failed to add Flathub repository"; exit 1; }

      echo "Getting list of currently installed Flatpak packages"
      installed_packages=$(${pkgs.flatpak}/bin/flatpak list --app --columns=application)
      echo "Currently installed packages: $installed_packages"

      echo "Installing or updating specified Flatpak packages"
      for pkg in ${lib.concatStringsSep " " flatpakPackages}; do
        echo "Processing package: $pkg"
        ${pkgs.flatpak}/bin/flatpak install --or-update -y flathub $pkg || { echo "Failed to install/update $pkg"; exit 1; }
        installed_packages=$(echo "$installed_packages" | grep -v "^$pkg$")
      done

      echo "Removing packages that are no longer in the flatpakPackages list"
      for pkg in $installed_packages; do
        echo "Removing Flatpak package: $pkg"
        ${pkgs.flatpak}/bin/flatpak uninstall -y $pkg || { echo "Failed to uninstall $pkg"; exit 1; }
      done

      echo "Flatpak setup script completed successfully"
    '';
    deps = [];
  };
}
