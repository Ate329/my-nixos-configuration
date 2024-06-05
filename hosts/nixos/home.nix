{
  config,
  pkgs,
  inputs,
  username,
  host,
  gtkThemeFromScheme,
  ...
}:
let
  palette = config.colorScheme.palette;

  # hyprlock variables
  textColor = "rgba(DFE3E7FF)";
  entryBackgroundColor = "rgba(0F141711)";
  entryBorderColor = "rgba(8B929755)";
  entryColor = "rgba(C1C7CEFF)";
  fontFamily = "Gabarito";
  fontFamilyClock = "Gabarito";
  fontMaterialSymbols = "Material Symbols Rounded";

  inherit (import ./variables.nix)
    gitUsername
    gitEmail
    theme
    ;
in
{
  # Home Manager Settings
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.11";

  # Set The Colorscheme
  colorScheme = inputs.nix-colors.colorSchemes."${theme}";

  # Import Program Configurations
  imports = [
    inputs.nix-colors.homeManagerModules.default
    inputs.hyprland.homeManagerModules.default
    ../../config/hyprland.nix
    ../../config/swaync.nix
    ../../config/waybar.nix
    ../../config/wlogout.nix
  ];

  # Define Settings For Xresources
  xresources.properties = {
    "Xcursor.size" = 24;
  };

  # Place Files Inside Home Directory
  home.file."Pictures/Wallpapers" = {
    source = ../../config/wallpapers;
    recursive = true;
  };
  home.file.".config/wlogout/icons" = {
    source = ../../config/wlogout;
    recursive = true;
  };
  home.file.".local/share/fonts" = {
    source = ../../config/fonts;
    recursive = true;
  };
  home.file.".config/starship.toml".source = ../../config/starship.toml;
  home.file.".config/ascii-neofetch".source = ../../config/ascii-neofetch;
  home.file.".base16-themes".source = ../../config/base16-themes;
  home.file.".emoji".source = ../../config/emoji;
  home.file.".face.icon".source = ../../config/face.jpg;
  home.file.".config/neofetch/config.conf".text = ''
    print_info() {
        prin "$(color 6)  ate329@nixos"
        info underline
        info "$(color 7)  VER" kernel
        info "$(color 2)  UP " uptime
        info "$(color 4)  PKG" packages
        info "$(color 6)  DE " de
        info "$(color 5)  TER" term
        info "$(color 3)  CPU" cpu
        info "$(color 7)  GPU" gpu
        info "$(color 5)  MEM" memory
        prin " "
        prin "$(color 1) $(color 2) $(color 3) $(color 4) $(color 5) $(color 6) $(color 7) $(color 8)"
    }
    distro_shorthand="on"
    memory_unit="gib"
    cpu_temp="C"
    separator=" $(color 4)>"
    stdout="off"
  '';
  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = /home/ate329/Pictures/Wallpapers/richard-horvath-_nWaeTF6qo0-unsplash.png
    wallpaper = eDP-1,/home/ate329/Pictures/Wallpapers/richard-horvath-_nWaeTF6qo0-unsplash.png
    splash = true
  '';  

  home.file.".config/swappy/config".text = ''
    [Default]
    save_dir=/home/${username}/Pictures/Screenshots
    save_filename_format=swappy-%Y%m%d-%H%M%S.png
    show_panel=false
    line_size=5
    text_size=20
    text_font=Ubuntu
    paint_mode=brush
    early_exit=true
    fill_shape=false
  '';

 home.file.".config/rofi/config.rasi".text = ''
    @theme "/dev/null"

    * {
      bg: #${palette.base00};
      background-color: @bg;
    }

    configuration {
      modi: "run,filebrowser,drun";
      show-icons: true;
      icon-theme: "Papirus";
      location: 0;
      font: "JetBrains Nerd Font 14";   
      drun-display-format: "{icon} {name}";
      display-drun: "   Apps ";
      display-run: "   Run ";
      display-filebrowser: "   File ";
    }

    window { 
      width: 35%;
      transparency: "real";
      orientation: vertical;
      border: 1px;
      border-color: #${palette.base04};
      border-radius: 7px;
    }

    mainbox {
      children: [ inputbar, listview, mode-switcher ];
    }

    element {
      padding: 6 12;
      text-color: #${palette.base05};
      border-radius: 4px;
    }

    element selected {
      text-color: #${palette.base01};
      background-color: #${palette.base0C};
    }

    element-text {
      background-color: inherit;
      text-color: inherit;
    }

    element-icon {
      size: 20px;
      background-color: inherit;
      padding: 0 5 0 0;
      alignment: vertical;
    }

    listview {
      columns: 1;
      lines: 7;
      padding: 6 0;
      fixed-height: true;
      fixed-columns: true;
      fixed-lines: true;
      border: 0 7 5 7;
    }

    entry {
      text-color: #${palette.base05};
      padding: 8 10 0 2;
      margin: 0 0 0 0;
    }

    inputbar {
      background-image: url("~/zaneyos/config/rofi.jpg", width);
      padding: 120 0 0 0;
      margin: 0 0 0 0;
    } 

    prompt {
      text-color: #${palette.base0D};
      padding: 8 8 0 9;
      margin: 0 0 0 0;
    }

    mode-switcher {
      border-color: #${palette.base0F};
      spacing: 0;
    }

    button {
      padding: 8px;
      background-color: @bg;
      text-color: #${palette.base01};
      vertical-align: 0.5; 
      horizontal-align: 0.5;
    }

    button selected {
      background-color: @bg;
      text-color: #${palette.base0F};
    }

    message {
      background-color: @bg;
      margin: 1px;
      padding: 1px;
      border-radius: 4px;
    }

    textbox {
      padding: 4px;
      margin: 15px 0px 0px 15px;
      text-color: #${palette.base0F};
      background-color: @bg;
    }
  '';

  # Install & Configure Git
  programs.git = {
    enable = true;
    userName = "${gitUsername}";
    userEmail = "${gitEmail}";
  };

  # Create XDG Dirs
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  # Configure Cursor Theme
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  # Theme GTK
  gtk = {
    enable = true;
    font = {
      name = "Ubuntu";
      size = 12;
      package = pkgs.ubuntu_font_family;
    };
    theme = {
      name = "${config.colorScheme.slug}";
      package = gtkThemeFromScheme { scheme = config.colorScheme; };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # Theme QT -> GTK
  qt = {
    enable = true;
    platformTheme = "gtk";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  services = {
    hypridle = {
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
        };
        listener = [
          {
            timeout = 300;
            on-timeout = "hyprlock";
          }
          {
            timeout = 600;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }  
        ];
      };
    };
  };

  # Scripts
  home.packages = [
    (import ../../scripts/emopicker9000.nix { inherit pkgs; })
    (import ../../scripts/task-waybar.nix { inherit pkgs; })
    (import ../../scripts/squirtle.nix { inherit pkgs; })
    (import ../../scripts/themechange.nix {
      inherit pkgs;
      inherit host;
      inherit username;
    })
    (import ../../scripts/theme-selector.nix { inherit pkgs; })
    (import ../../scripts/nvidia-offload.nix { inherit pkgs; })
    (import ../../scripts/wallsetter.nix {
      inherit pkgs;
      inherit username;
    })
    (import ../../scripts/web-search.nix { inherit pkgs; })
    (import ../../scripts/rofi-launcher.nix { inherit pkgs; })
    (import ../../scripts/screenshootin.nix { inherit pkgs; })
    (import ../../scripts/list-hypr-bindings.nix {
      inherit pkgs;
      inherit host;
    })
  ];

  programs = {
    gh.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      extraPackages = with pkgs; [
        lua-language-server
        gopls
        xclip
        wl-clipboard
        luajitPackages.lua-lsp
        nil
        rust-analyzer
        nodePackages.bash-language-server
        yaml-language-server
        pyright
        marksman
      ];
      plugins = with pkgs.vimPlugins; [
        alpha-nvim
        auto-session
        bufferline-nvim
        dressing-nvim
        indent-blankline-nvim
        nvim-treesitter.withAllGrammars
        lualine-nvim
        nvim-autopairs
        nvim-web-devicons
        nvim-cmp
        nvim-surround
        nvim-lspconfig
        cmp-nvim-lsp
        cmp-buffer
        luasnip
        cmp_luasnip
        friendly-snippets
        lspkind-nvim
        comment-nvim
        nvim-ts-context-commentstring
        {
          plugin = dracula-nvim;
          config = "colorscheme dracula";
        }
        plenary-nvim
        neodev-nvim
        luasnip
        telescope-nvim
        todo-comments-nvim
        nvim-tree-lua
        telescope-fzf-native-nvim
        vim-tmux-navigator
      ];
      extraConfig = ''
        set noemoji
      '';
      extraLuaConfig = ''
        ${builtins.readFile ../../config/nvim/options.lua}
        ${builtins.readFile ../../config/nvim/keymaps.lua}
        ${builtins.readFile ../../config/nvim/plugins/alpha.lua}
        ${builtins.readFile ../../config/nvim/plugins/autopairs.lua}
        ${builtins.readFile ../../config/nvim/plugins/auto-session.lua}
        ${builtins.readFile ../../config/nvim/plugins/comment.lua}
        ${builtins.readFile ../../config/nvim/plugins/cmp.lua}
        ${builtins.readFile ../../config/nvim/plugins/lsp.lua}
        ${builtins.readFile ../../config/nvim/plugins/nvim-tree.lua}
        ${builtins.readFile ../../config/nvim/plugins/telescope.lua}
        ${builtins.readFile ../../config/nvim/plugins/todo-comments.lua}
        ${builtins.readFile ../../config/nvim/plugins/treesitter.lua}
        require("ibl").setup()
        require("bufferline").setup{}
        require("lualine").setup({
          icons_enabled = true,
          theme = 'dracula',
        })
      '';
    };

    kitty = {
      enable = true;
      package = pkgs.kitty;
      font.name = "JetBrainsMono Nerd Font";
      font.size = 14;
      settings = {
        scrollback_lines = 2000;
        wheel_scroll_min_lines = 1;
        window_padding_width = 4;
        confirm_os_window_close = 0;
        background_opacity = "0.9";
      };
      extraConfig = ''
        foreground #${palette.base05}
        background #${palette.base00}
        color0  #${palette.base03}
        color1  #${palette.base08}
        color2  #${palette.base0B}
        color3  #${palette.base09}
        color4  #${palette.base0D}
        color5  #${palette.base0E}
        color6  #${palette.base0C}
        color7  #${palette.base06}
        color8  #${palette.base04}
        color9  #${palette.base08}
        color10 #${palette.base0B}
        color11 #${palette.base0A}
        color12 #${palette.base0C}
        color13 #${palette.base0E}
        color14 #${palette.base0C}
        color15 #${palette.base07}
        color16 #${palette.base00}
        color17 #${palette.base0F}
        color18 #${palette.base0B}
        color19 #${palette.base09}
        color20 #${palette.base0D}
        color21 #${palette.base0E}
        color22 #${palette.base0C}
        color23 #${palette.base06}
        cursor  #${palette.base07}
        cursor_text_color #${palette.base00}
        selection_foreground #${palette.base01}
        selection_background #${palette.base0D}
        url_color #${palette.base0C}
        active_border_color #${palette.base04}
        inactive_border_color #${palette.base00}
        bell_border_color #${palette.base03}
        tab_bar_style fade
        tab_fade 1
        active_tab_foreground   #${palette.base04}
        active_tab_background   #${palette.base00}
        active_tab_font_style   bold
        inactive_tab_foreground #${palette.base07}
        inactive_tab_background #${palette.base08}
        inactive_tab_font_style bold
        tab_bar_background #${palette.base00}
      '';
    };

    starship = {
      enable = true;
      package = pkgs.starship;
    };

    wofi = {
      enable = true;
      settings = {
        allow_images = true;
        prompt = "Run Programs...";
        width = "35%";
        hide_scroll = true;
        term = "kitty";
        show = "drun";
      };

      style = ''
        * {
          font-family: JetBrainsMono Nerd Font Mono,monospace;
          font-weight: bold;
        }
        #window {
          border-radius: 25px;
          border: 2px solid #${palette.base08};
          background: #${palette.base00};
        }
        #input {
          border-radius: 10px;
          border: 2px solid #${palette.base0B};
          margin: 20px;
          padding: 15px 25px;
          background: #${palette.base00};
          color: #${palette.base05};
        }
        #inner-box {
          border: none;
          background-color: transparent;
        }
        #outer-box {
          border: none;
          font-weight: bold;
          font-size: 14px;
        }
        #text {
          border: none;
        }
        #entry {
          margin: 10px 80px;
          padding: 20px 20px;
          border-radius: 10px;
          border: none;
        }
        #entry:focus {
          border: none;
        }
        #entry:hover {
          border: none;
        }
        #entry:selected {
          background-color: #${palette.base0F};
          color: #${palette.base00};
        }
      '';
    };
    bash = {
      enable = true;
      enableCompletion = true;
      profileExtra = ''
        #if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        #  exec Hyprland
        #fi
      '';
      initExtra = ''
        neofetch
        if [ -f $HOME/.bashrc-personal ]; then
          source $HOME/.bashrc-personal
        fi
      '';
      shellAliases = {
        sv = "sudo nvim";
        flake-rebuild = "nh os switch --hostname ${host} /home/${username}/zaneyos";
        flake-update = "nh os switch --hostname ${host} --update /home/${username}/zaneyos";
        flake-rebuild-impure = "sudo nixos-rebuild switch --flake /home/${username}/zaneyos#${host} --impure";
	gcCleanup = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
        v = "nvim";
        ls = "lsd";
        ll = "lsd -l";
        la = "lsd -a";
        lal = "lsd -al";
        ".." = "cd ..";
        neofetch="neofetch --ascii ~/.config/ascii-neofetch";
      };
    };
    home-manager.enable = true;

    hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = false;
          grace = 10;
          hide_cursor = true;
          no_fade_in = false;
          ignore_empty_input = false;
        };
        background = [
          {
            color = "rgb(15, 20, 23)";
            path = "/home/${username}/zaneyos/config/hyprlock.jpg";
            blur_size = 5;
            blur_passes = 4;
          }
        ];
        input-field = [
          {
            size = "500, 100";
            monitor = "";
            outline_thickness = 2;
            dots_size = 0.1;
            dots_spacing = 0.3;
            outer_color = "rgb(139, 146, 151)";
            inner_color = "rgb(52, 177, 235)";
            font_color = "rgb(193, 199, 206)";

            position = "0, 0";
            dots_center = true;
            fade_on_empty = true;
          }
        ];
      };
    };
  };
}
