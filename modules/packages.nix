{ config, pkgs, inputs, ... }:    
{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     sl
     (wechat-uos.override { uosLicense = ./license.tar.gz; })
     okular
     discord
     deja-dup
     neofetch
     uwufetch
     teams-for-linux
     gimp
     wineWowPackages.unstableFull
     wineWowPackages.stagingFull
     gcc
     wine
     wine64
     winetricks
     wineWowPackages.stable
     (wine.override { wineBuild = "wine64"; })
     wineWowPackages.staging
     wineWowPackages.waylandFull
     git
     grub2
     gh
     unzip
     zip
     rippkgs
     gnome.gnome-tweaks
     obsidian
     miru
     ani-cli
     lolcat
     spotify
     spotify-qt
     gnomeExtensions.mute-spotify-ads
     nix-inspect
     krita
     btop
     lutris
     htop
     cmake
     gnumake
     tree
     firefox
     thunderbird
     cargo
     vscode
     auto-cpufreq
     libreoffice
  ];
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];
}
