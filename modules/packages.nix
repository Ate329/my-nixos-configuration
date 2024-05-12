{ config, pkgs, inputs, ... }:    
{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     alacritty
     picom
     rofi
     nh
     hyprland
     waybar
     eww
     (waybar.overrideAttrs (oldAttrs: {
     mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
       	})
     )
     dunst
     mako
     libnotify
     xdg-desktop-portal-gtk
     nitrogen
     xfce.mousepad
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
     gcc
     #fcitx5
     #fcitx5-rime
     #fcitx5-mozc
     #fcitx5-skk
     #fcitx5-lua
     #fcitx5-gtk
     ibus
     ibus-with-plugins
     ibus-engines.rime
     ibus-theme-tools
     xorg.xdpyinfo
     winePackages.fonts
     wine64Packages.fonts
     wineWowPackages.fonts
     wineWow64Packages.fonts
     winePackages.unstableFull
     winePackages.staging
     wine64Packages.unstableFull
     wine64Packages.staging
     wine-staging
     wineWow64Packages.full
     wineWow64Packages.unstableFull
     wineWow64Packages.stagingFull
     wineWowPackages.full
     wineWowPackages.unstableFull
     wineWowPackages.stagingFull
     wine
     wine64
     winetricks
     wineWowPackages.stable
     (wine.override { wineBuild = "wine64"; })
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
     qtile
     awesome
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
