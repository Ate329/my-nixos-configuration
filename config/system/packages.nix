{ pkgs, config, inputs, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  #environment.etc."license.tar.gz".source = ~/zaneyos/license.tar.gz;
 
  # List System Programs
  environment.systemPackages = with pkgs; [
    wget curl git cmatrix lolcat neofetch htop btop libvirt
    polkit_gnome lm_sensors unzip unrar libnotify eza
    v4l-utils ydotool wl-clipboard socat cowsay lsd lshw
    pkg-config meson hugo gnumake ninja go nodejs symbola
    noto-fonts-color-emoji material-icons brightnessctl
    toybox virt-viewer swappy ripgrep appimage-run 
    networkmanagerapplet yad playerctl nh grub2
    heroic
    prismlauncher
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    sl
    alacritty
    (wechat-uos.override { uosLicense = /home/ate329/zaneyos/license.tar.gz; })
    okular
    discord
    deja-dup
    uwufetch
    waydroid
    teams-for-linux
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
    gh
    unzip
    zip
    gnome.gnome-tweaks
    obsidian
    miru
    ani-cli
    spotify
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
    vscode-fhs
    auto-cpufreq
    libreoffice
  ];
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  programs = {
    steam.gamescopeSession.enable = true;
    dconf.enable = true;
    seahorse.enable=true;
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      xwayland.enable = true;
    };
    fuse.userAllowOther = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    virt-manager.enable = true;
  };

  virtualisation.libvirtd.enable = true;
}
