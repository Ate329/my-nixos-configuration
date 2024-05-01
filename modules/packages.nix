{ config, pkgs, inputs, ... }:    
{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     sl
     discord
     deja-dup
     neofetch
     uwufetch
     teams-for-linux
     gimp
     gcc
     wine
     wine64
     winetricks
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
     spotifyd
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
}
