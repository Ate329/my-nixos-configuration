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
      # Add Flathub repository
      ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

      # Get list of currently installed Flatpak packages
      installed_packages=$(${pkgs.flatpak}/bin/flatpak list --app --columns=application)

      # Install or update specified Flatpak packages
      for pkg in ${lib.concatStringsSep " " flatpakPackages}; do
        ${pkgs.flatpak}/bin/flatpak install --or-update -y flathub $pkg
        # Remove the package from the list of installed packages
        installed_packages=$(echo "$installed_packages" | grep -v "^$pkg$")
      done

      # Remove packages that are no longer in the flatpakPackages list
      for pkg in $installed_packages; do
        echo "Removing Flatpak package: $pkg"
        ${pkgs.flatpak}/bin/flatpak uninstall -y $pkg
      done
    '';
    deps = [];
  };
}
