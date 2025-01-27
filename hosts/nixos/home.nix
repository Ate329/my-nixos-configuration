{
  config,
  pkgs,
  inputs,
  username,
  host,
  ...
}:

let
  inherit (config.lib.stylix) colors;
  inherit (import ./variables.nix) gitUsername gitEmail;
in
{
  # Home Manager Settings
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.11";

  # Import Program Configurations
  imports = [
    # inputs.hyprland.homeManagerModules.default
    inputs.spicetify-nix.homeManagerModules.default
    inputs.catppuccin.homeManagerModules.catppuccin
    ../../home/programs/hypr/default.nix
    ../../home/programs/rofi/default.nix
    # ../../home/programs/fastfetch/default.nix
    ../../home/programs/swaync.nix
    ../../home/programs/waybar.nix
    ../../home/programs/wlogout.nix
    ../../home/programs/waypaper.nix
    ../../home/programs/fcitx5.nix
    ../../modules/pkgs/custom-packages/spicetify.nix
  ];

  # Place Files Inside Home Directory
  home.file."Pictures/Wallpapers" = {
    source = ../../home/themes/wallpapers;
    recursive = true;
  };
  home.file.".config/wlogout/icons" = {
    source = ../../home/programs/wlogout;
    recursive = true;
  };
  home.file.".local/share/fonts" = {
    source = ../../home/themes/fonts;
    recursive = true;
  };
  home.file.".config/fish/fish_variables".source = ../../home/shell/fish_variables;
  home.file.".config/starship.toml".source = ../../home/shell/starship.toml;
  home.file.".config/ascii-neofetch".source = ../../home/shell/ascii-neofetch;
  home.file.".base16-themes".source = ../../home/themes/base16-themes;
  home.file.".emoji".source = ../../home/shell/emoji;
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

  /*
    home.file.".config/hypr/hyprpaper.conf".text = ''
      preload = /home/ate329/Pictures/Wallpapers/azusa_flower_crop.png
      wallpaper = eDP-1,/home/ate329/Pictures/Wallpapers/azusa_flower_crop.png
      splash = true
    '';
  */

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

  # Theme GTK
  gtk = {
    enable = true;
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
    style.name = "kvantum";
    platformTheme.name = "kvantum";
  };

  catppuccin = {
    enable = false;
    starship.enable = false;
    flavor = "macchiato";
  };

  # Scripts
  home.packages = [
    (import ../../home/scripts/emopicker9000.nix { inherit pkgs; })
    (import ../../home/scripts/task-waybar.nix { inherit pkgs; })
    (import ../../home/scripts/squirtle.nix { inherit pkgs; })
    (import ../../home/scripts/themechange.nix {
      inherit pkgs;
      inherit host;
      inherit username;
    })
    (import ../../home/scripts/theme-selector.nix { inherit pkgs; })
    (import ../../home/scripts/nvidia-offload.nix { inherit pkgs; })
    (import ../../home/scripts/wallsetter.nix {
      inherit pkgs;
      inherit username;
    })
    (import ../../home/scripts/web-search.nix { inherit pkgs; })
    (import ../../home/scripts/rofi-launcher.nix { inherit pkgs; })
    (import ../../home/scripts/screenshootin.nix { inherit pkgs; })
    (import ../../home/scripts/list-hypr-bindings.nix {
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
        ${builtins.readFile ../../home/programs/nvim/options.lua}
        ${builtins.readFile ../../home/programs/nvim/keymaps.lua}
        ${builtins.readFile ../../home/programs/nvim/plugins/alpha.lua}
        ${builtins.readFile ../../home/programs/nvim/plugins/autopairs.lua}
        ${builtins.readFile ../../home/programs/nvim/plugins/auto-session.lua}
        ${builtins.readFile ../../home/programs/nvim/plugins/comment.lua}
        ${builtins.readFile ../../home/programs/nvim/plugins/cmp.lua}
        ${builtins.readFile ../../home/programs/nvim/plugins/lsp.lua}
        ${builtins.readFile ../../home/programs/nvim/plugins/nvim-tree.lua}
        ${builtins.readFile ../../home/programs/nvim/plugins/telescope.lua}
        ${builtins.readFile ../../home/programs/nvim/plugins/todo-comments.lua}
        ${builtins.readFile ../../home/programs/nvim/plugins/treesitter.lua}
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
      settings = {
        scrollback_lines = 2000;
        wheel_scroll_min_lines = 1;
        window_padding_width = 4;
        confirm_os_window_close = 0;
      };
    };

    starship = {
      enable = true;
      package = pkgs.starship;
    };

    bash = {
      enable = false;
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
        flake-rebuild = "nh os switch --hostname ${host} /home/${username}/nix-config";
        flake-update = "nh os switch --hostname ${host} --update /home/${username}/nix-config";
        flake-rebuild-impure = "sudo nixos-rebuild switch --flake /home/${username}/nix-config#${host} --impure";
        gcCleanup = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
        v = "nvim";
        ls = "lsd";
        ll = "lsd -l";
        la = "lsd -a";
        lal = "lsd -al";
        ".." = "cd ..";
        neofetch = "neofetch --ascii ~/.config/ascii-neofetch";
        tsvpn = "tailscale up --accept-routes --exit-node=100.64.0.4 --login-server=https://headscale.ate329.nohost.me --accept-dns --operator=$USER";
        ssh = "kitten ssh";
      };
    };
    home-manager.enable = true;
  };
}
