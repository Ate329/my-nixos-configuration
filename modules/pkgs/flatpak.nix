{ lib, pkgs, ... }:

let
  # Define the list of Flatpak packages
  flatpakPackages = [
    # Add packages here
    "org.blender.Blender"
  ];
in
{
  services.flatpak.enable = true;

  # Ensure the Flathub repository is added
  systemd.services.flatpak-repo = {
    description = "Add Flathub repository to Flatpak";
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];  # Ensure the Flatpak binary is available
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  # Install Flatpak packages
  systemd.services.install-flatpak-packages = {
    description = "Install Flatpak packages";
    wantedBy = [ "multi-user.target" ];
    after = [ "flatpak-repo.service" ];  # Ensure it runs after the repo is added
    path = [ pkgs.flatpak ];  # Ensure the Flatpak binary is available
    script = ''
      # Iterate over the list of Flatpak packages and install them if not already installed
      for pkg in ${lib.concatStringsSep " " flatpakPackages}; do
        if ! flatpak info $pkg > /dev/null 2>&1; then
          flatpak install -y flathub $pkg
        fi
      done
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}
