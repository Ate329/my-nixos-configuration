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
  imports = [
    ./hardware.nix
    ./users.nix
    ../../modules/amd-drivers.nix
    ../../modules/nvidia-drivers.nix
    ../../modules/nvidia-prime-drivers.nix
    ../../modules/intel-drivers.nix
    ../../modules/vm-guest-services.nix
    ../../modules/local-hardware-clock.nix
  ];

  # Kernel
  # boot.kernelPackages = pkgs.linuxPackages;
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelPackages = pkgs.linuxPackages_6_8;

  # Bootloader.
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      gfxmodeEfi = "1024x768x32";
      fontSize = 36;
    };
  };

  # This is for OBS Virtual Cam Support - v4l2loopback setup
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "${host}";
  networking.timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];

  # Set your time zone.
  time.timeZone = "Europe/Athens";
  services.automatic-timezoned.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      xwayland.enable = true;
    };

    firefox.enable = true;
    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    virt-manager.enable = true;

    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];
    };

    # nh config
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/ate329/zaneyos";
    };
    
    # auto-cpufreq config
    auto-cpufreq = {
      enable = true;
      
      settings = {
        charger = {
          governor = "performance";
          turbo = "auto";
        };

        battery = {
          governor = "powersave";
          turbo = "never";
        };
      };
    }; 
  };

  nixpkgs.config.allowUnfree = true;

  environment.variables = {
    FLAKE = "/home/ate329/zaneyos";
  };

  users = {
    mutableUsers = true;
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-extra  
    noto-fonts-cjk-serif 
    noto-fonts-cjk-sans
    noto-fonts-emoji
    noto-fonts-lgc-plus
    noto-fonts-color-emoji
    nerdfonts
  ];

  environment.systemPackages =
    let
      sugar = pkgs.callPackage ../../pkgs/sddm-sugar-dark.nix { };
      tokyo-night = pkgs.libsForQt5.callPackage ../../pkgs/sddm-tokyo-night.nix { };
    in
    with pkgs;
    [
      vim
      wget
      git
      cmatrix
      lolcat
      neofetch
      htop
      libsForQt5.qt5.qtquickcontrols2
      libsForQt5.qt5.qtgraphicaleffects
      libvirt
      lxqt.lxqt-policykit
      mangohud
      blueman
      lm_sensors
      unzip
      bluez
      unrar
      libnotify
      eza
      v4l-utils
      ydotool
      auto-cpufreq
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
      noto-fonts-color-emoji
      material-icons
      brightnessctl
      virt-viewer
      swappy
      rofi-wayland
      appimage-run
      networkmanagerapplet
      yad
      python310Full
      python39Full
      python311Full
      python312Full
      python311Packages.tkinter
      python310Packages.tkinter
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
      gnome.gnome-power-manager
      dmenu
      tesseract
      cliphist
      slurp
      gnome.file-roller
      swaynotificationcenter
      imv
      transmission-gtk
      distrobox
      mpv
      killall
      gimp
      obs-studio
      rustup
      audacity
      pavucontrol
      tree
      protonup-qt
      font-awesome
      spotify
      neovide
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      sugar.sddm-sugar-dark # Name: sugar-dark
      tokyo-night # Name: tokyo-night-sddm
      pkgs.libsForQt5.qt5.qtgraphicaleffects
      #wineWowPackages.stagingFull
      wine
      wine64
      winetricks
      #wineWowPackages.stable
      (wine.override { wineBuild = "wine64"; })
      #wineWowPackages.waylandFull
      git
      gh
      unzip
      zip
      gnome.gnome-tweaks
      #obsidian
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
      (wechat-uos.override { uosLicense = ../../config/license.tar.gz; })
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
      #wineWowPackages.fonts
      #wineWow64Packages.fonts
      winePackages.unstableFull
      winePackages.staging
      wine64Packages.unstableFull
      wine64Packages.staging
      wine-staging
      #wineWow64Packages.full
      #wineWow64Packages.unstableFull
      #wineWow64Packages.stagingFull
      #wineWowPackages.full
      #wineWowPackages.unstableFull
      heroic
      prismlauncher
      vim # Do not forget to add an editor to edit configuration.nix! >
      sl
      alacritty    
    ];

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  environment.variables = {
    ZANEYOS_VERSION = "2.0";
    ZANEYOS = "true";
  };

  # Services to start
  services = {
    xserver = {
      enable = true;

      displayManager.sddm = {
        enable = true;
        autoNumlock = true;
        wayland.enable = true;
        theme = "${import ../../pkgs/where-is-my-sddm-theme.nix {inherit pkgs;}}";
      };

      displayManager.gdm.enable = false;
      desktopManager.gnome.enable = true;
      desktopManager.cinnamon.enable = false;

      xkb = {
        layout = "us";
        variant = "";
      };
    };

    smartd = {
      enable = true;
      autodetect = true;
    };

    libinput.enable = true;
    openssh.enable = true;
    flatpak.enable = false;
    printing.enable = true;
    gnome.gnome-keyring.enable = true;

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    ipp-usb.enable = true;

    syncthing = {
      enable = false;
      user = "${username}";
      dataDir = "/home/${username}";
      configDir = "/home/${username}/.config/syncthing";
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    rpcbind.enable = true;
    nfs.server.enable = true;

    logind.extraConfig = ''
       # don’t shutdown when power button is short-pressed
       HandlePowerKey=ignore
       IdleAction=suspend
       IdleActionSec=600
     '';
  };

  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
    disabledDefaultBackends = [ "escl" ];
  };
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;

  # Enable sound with pipewire.
  sound.enable = true;

  # Bluetooth
  hardware.bluetooth = {
    enable = true; # enables support for Bluetooth
    powerOnBoot = true; # powers up the default Bluetooth controller on boot
    
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };

  services.blueman.enable = true; # paring
  
  hardware.pulseaudio = {
    enable = false;
    package = pkgs.pulseaudioFull;
  };
  
  # Bluetooth headset control
  systemd.user.services.mpris-proxy = {
    description = "Mpris proxy";
    after = [ "network.target" "sound.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  };

  # Security / Polkit
  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )
        )
      {
        return polkit.Result.YES;
      }
    })
  '';

  # Optimization settings and garbage collection automation
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # automatic upgrade
  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
    ];
    dates = "18:30";
    randomizedDelaySec = "60min";
  };

  # Virtualization / Containers
  virtualisation.libvirtd.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Extra Module Options
  drivers.amdgpu.enable = true;
  drivers.nvidia.enable = false;
  drivers.nvidia-prime = {
    enable = false;
    intelBusID = "";
    nvidiaBusID = "";
  };
  drivers.intel.enable = false;
  vm.guest-services.enable = false;
  local.hardware-clock.enable = false;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
