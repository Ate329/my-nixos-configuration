{ pkgs, ... }:
{
  # Styling Options
  stylix = {
    enable = true;
    image = ../../home/themes/wallpapers/azusa_flower_crop.png;
    # disable if you want to generate colorscheme by picture
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    autoEnable = true;

    targets = {
      grub = {
        enable = false;
        useImage = false;
      };
      fish.enable = false;
    };

    polarity = "dark";
    opacity.terminal = 0.85;
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 24;
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.ubuntu_font_family;
        name = "Ubuntu";
      };
      serif = {
        package = pkgs.ubuntu_font_family;
        name = "Ubuntu";
      };
      sizes = {
        applications = 13;
        terminal = 14;
        desktop = 12;
        popups = 12;
      };
    };
  };

  home-manager.sharedModules = [
    {
      stylix = {
        targets = {
          rofi.enable = false;
          waybar.enable = false;
          spicetify.enable = false;
          fish.enable = false;
          kitty = {
            enable = true;
            variant256Colors = true;
          };
        };
      };
    }
  ];
}
