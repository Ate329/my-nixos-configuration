{
  config,
  pkgs,
  host,
  inputs,
  username,
  options,
  ...
}:

{
  environment.systemPackages =
    let
      sugar = pkgs.callPackage ./sddm-themes/sddm-sugar-dark.nix { };
      tokyo-night = pkgs.libsForQt5.callPackage ./sddm-themes/sddm-tokyo-night.nix { };
    in
    with pkgs;
    [
      vim
      wget
      git
      gparted
      nmap
      xwaylandvideobridge
      xwayland-satellite
      xwayland-run
      hping
      rename
      mupdf
      calibre
      qalculate-qt
      xdotool
      zenith
      opendrop
      nomacs
      adwaita-icon-theme
      adwaita-qt
      adwsteamgtk
      psmisc
      amf
      vaapi-intel-hybrid
      libva
      libva-vdpau-driver
      libva-utils
      ladybird
      mesa
      vdpauinfo
      jq
      amdenc
      amd-blis
      youtube-tui
      bilibili
      amdgpu_top
      qq
      microcode-amd
      zenmonitor
      stress
      virtualbox
      getent
      iconv
      glibc_memusage
      alsa-utils
      ventoy-full
      minecraft
      gamescope
      gamescope-wsi
      clinfo
      tailscale
      webcord
      vesktop
      jstest-gtk
      linuxConsoleTools
      metasploit
      tcpreplay
      evhz
      cmatrix
      mcrcon
      lolcat
      jellyfin
      jellyfin-web
      jellyfin-media-player
      tor-browser
      neofetch
      htop
      gnome-boxes
      libsForQt5.qt5.qtquickcontrols2
      libsForQt5.qt5.qtgraphicaleffects
      libvirt
      lxqt.lxqt-policykit
      logisim-evolution
      stdenv.cc.cc.lib
      libcxx
      libgcc
      gnat
      glibc
      mangohud
      blueman
      lm_sensors
      unzip
      bluez
      unrar
      libnotify
      rpi-imager
      eza
      v4l-utils
      ydotool
      #auto-cpufreq
      wl-clipboard
      lm_sensors
      pciutils
      socat
      cowsay
      ripgrep
      lsd
      lshw
      pkg-config
      meson
      gnumake
      ninja
      symbola
      libstdcxx5
      noto-fonts-color-emoji
      material-icons
      brightnessctl
      virt-viewer
      swappy
      rofi-wayland
      appimage-run
      networkmanagerapplet
      yad
      python311Full
      python312Full
      python3Full
      python311Packages.pip
      python312Packages.pip
      python311Packages.django
      jupyter
      playerctl
      nh
      nixfmt-rfc-style
      discord
      libvirt
      swww
      hyprpaper
      swaybg
      # nodePackages_latest.webtorrent-cli
      webtorrent_desktop
      clash-verge-rev
      grim
      hypridle
      waypaper
      nodejs_22
      nodejs_20
      nodejs_18
      heroic
      vlc
      neovim-qt
      neovim
      gnome-power-manager
      dmenu
      tesseract
      cliphist
      slurp
      file-roller
      swaynotificationcenter
      imv
      transmission_3-gtk
      transmission_4-gtk
      distrobox
      mpv
      gimp
      rustup
      audacity
      pavucontrol
      tree
      protonup-qt
      font-awesome
      neovide
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      sugar.sddm-sugar-dark # Name: sugar-dark
      tokyo-night # Name: tokyo-night-sddm
      pkgs.libsForQt5.qt5.qtgraphicaleffects
      wine
      wine64
      winetricks
      wine-wayland
      winePackages.stableFull
      winePackages.waylandFull
      wine64Packages.stableFull
      wine64Packages.waylandFull
      wineWowPackages.stableFull
      wineWowPackages.waylandFull
      wineWow64Packages.stableFull
      wineWow64Packages.waylandFull
      git
      gh
      unzip
      zip
      gnome-tweaks
      obsidian
      zed-editor
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
      libreoffice
      (wechat-uos.override { uosLicense = ./license.tar.gz; })
      okular
      discord
      deja-dup
      uwufetch
      waydroid
      teams-for-linux
      gcc
      gcc-unwrapped
      ibus
      ibus-with-plugins
      ibus-engines.rime
      ibus-theme-tools
      xorg.xdpyinfo
      winePackages.fonts
      wine64Packages.fonts
      wineWowPackages.fonts
      wineWow64Packages.fonts
      heroic
      prismlauncher
      fastfetch
      vim
      sl
      alacritty
    ];

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
    "electron-27.3.11"
  ];

  nixpkgs.config.allowBroken = true;
}
