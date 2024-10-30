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
    ../../home/themes/stylix.nix
    ../../home/scripts/power-manager.nix
    ../../modules/hardware/amd-drivers.nix
    ../../modules/hardware/nvidia-drivers.nix
    ../../modules/hardware/nvidia-prime-drivers.nix
    ../../modules/hardware/intel-drivers.nix
    ../../modules/services/vm-guest-services.nix
    ../../modules/services/local-hardware-clock.nix
    ../../modules/services/restart-apps.nix
    ../../modules/pkgs/pkgs.nix
    ../../modules/pkgs/custom-packages/auto-cpufreq.nix
    ../../modules/pkgs/custom-packages/noise-suppression.nix
    ../../modules/pkgs/custom-packages/steam.nix
    ../../modules/pkgs/flatpak.nix
  ];

  /*
    services.flatpak = {
      enable = true;
      packages = [ "org.gnome.Calculator" ];
      removeUnmanagedPackages = true;
      update = {
        auto = {
          enable = true;
          onCalendar = "weekly";
        };
        duringBuild = false;
      };
      remote = {
        name = "flathub";
        url = "https://flathub.org/repo/flathub.flatpakrepo";
      };
    };
  */

  boot = {
    # Kernel
    # kernelPackages = pkgs.linuxPackages;
    kernelPackages = pkgs.linuxPackages_latest;
    # kernelPackages = pkgs.linuxPackages_zen;
    # kernelPackages = pkgs.linuxPackages_6_1;

    # This is for OBS Virtual Cam Support
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback.out ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS VCam" exclusive_caps=1
    '';

    # Needed For Some Steam Games
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };

    kernelParams = [
      "video=eDP-1:2880x1800@120"
      "video=HDMI-A-1:2560x1440@144"
    ];

    initrd.kernelModules = [ "amdgpu" ];

    # Bootloader.
    loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        #gfxmodeEfi = "1024x576x32";
        #font = "/home/${username}/nix-config/home/themes/fonts/JetBrainsMono.ttf";
        fontSize = 48;
        configurationLimit = 1000;
        useOSProber = false;
        extraEntries = ''
            	  menuentry "Reboot" --class restart {
                    reboot
            	  }
            	  menuentry "Poweroff" --class shutdown {
              	    halt
            	  }
            	  menuentry "UEFI Setup" --class efi {
              	    fwsetup
            	  }
          	'';
      };
      grub2-theme = {
        enable = true;
        theme = "stylish";
        #screen = "custom";
        #splashImage = /home/${username}/nix-config/home/themes/wallpapers/azusa_flower_crop.png;
        customResolution = "2880x1800";
        icon = "color";
        footer = true;
      };
    };

    # Make /tmp a tmpfs
    tmp = {
      useTmpfs = false;
      tmpfsSize = "30%";
    };

    # Appimage Support
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };

    plymouth.enable = true;
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking = {
    /*
      nameservers = [ "1.1.1.1" "2606:4700:4700::1111"
      		    "1.0.0.1" "2606:4700:4700::1001"];
    */

    # If using dhcpcd:
    #dhcpcd.extraConfig = "nohook resolv.conf";
    # If using NetworkManager:
    networkmanager.dns = "default";
  };

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "${host}";
  networking.timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];

  # Set your time zone.
  time.timeZone = "Europe/Athens";
  services.automatic-timezoned.enable = false;

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

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        rime-data
        fcitx5-rime
        fcitx5-chinese-addons
        fcitx5-pinyin-moegirl
        fcitx5-gtk
        fcitx5-mozc
        fcitx5-skk
        fcitx5-lua
        fcitx5-chewing
        libsForQt5.fcitx5-qt
        fcitx5-tokyonight
        fcitx5-rose-pine
      ];
    };
  };

  programs = {
    hyprlock.enable = true;

    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      xwayland.enable = true;
      systemd.setPath.enable = true;
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

    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };

    # nh config
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/ate329/nix-config";
    };

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        waveform
        input-overlay
        obs-vaapi
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vkcapture
      ];
    };
  };

  nix.extraOptions = ''
    trusted-users = root ate329
  '';

  hardware.xone.enable = true; # support for the xbox controller USB dongle

  nixpkgs.config.allowUnfree = true;

  environment.variables = {
    FLAKE = "/home/ate329/nix-config";
  };

  users = {
    mutableUsers = true;
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-extra
    noto-fonts-cjk-serif
    noto-fonts-cjk-sans
    noto-fonts-emoji
    noto-fonts-lgc-plus
    noto-fonts-color-emoji
    nerdfonts
    cantarell-fonts
  ];

  environment.variables = {
    ZANEYOS_VERSION = "2.0";
    ZANEYOS = "true";
  };

  # Services to start
  services = {
    hypridle.enable = true;

    displayManager.sddm = {
      enable = true;
      autoNumlock = true;
      wayland.enable = true;
      theme = "${import ../../modules/pkgs/sddm-themes/where-is-my-sddm-theme.nix { inherit pkgs; }}";
    };

    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };

    xserver = {
      enable = true;

      displayManager.gdm.enable = false;
      desktopManager.gnome.enable = false;
      desktopManager.cinnamon.enable = false;

      xkb = {
        layout = "us";
        variant = "";
      };
    };

    gvfs.enable = true;

    smartd = {
      enable = true;
      autodetect = true;
    };

    libinput.enable = true;
    openssh.enable = true;
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

      wireplumber.extraConfig = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.roles" = [
            "hsp_hs"
            "hsp_ag"
            "hfp_hf"
            "hfp_ag"
          ];
        };
      };
    };

    rpcbind.enable = true;
    nfs.server.enable = true;

    power-profiles-daemon.enable = true;

    logind = {
      powerKeyLongPress = "poweroff";
      lidSwitchExternalPower = "ignore";
      extraConfig = ''
        # don’t shutdown when power button is short-pressed
        HandlePowerKey=ignore
        IdleAction=suspend
        IdleActionSec=600
      '';
    };

    ollama = {
      enable = true;
      acceleration = "rocm";
    };

    open-webui = {
      enable = false;
    };
  };

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
    disabledDefaultBackends = [ "escl" ];
  };
  hardware.logitech.wireless.enable = false;
  hardware.logitech.wireless.enableGraphical = false;

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
    after = [
      "network.target"
      "sound.target"
    ];
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  };

  programs.java.enable = true;

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
      automatic = false;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # automatic upgrade
  system.autoUpgrade = {
    enable = false;
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
  networking.firewall.allowedTCPPorts = [ 22 ];
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
