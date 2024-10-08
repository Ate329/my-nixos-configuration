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
# Styling Options
  stylix = {
    enable = true;
    image = ../../home/themes/wallpapers/azusa_flower_crop.png;
    # disable if you want to generate colorscheme by picture
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    autoEnable = false;

    polarity = "dark";
    opacity.terminal = 0.9;
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 24;
    fonts = {
      monospace = {
        package = pkgs.nerdfonts;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 14;
        desktop = 11;
        popups = 12;
      };
    };
  };
  home-manager.sharedModules = [{
    stylix = {
      targets = {
        rofi.enable = false;
        hyprland.enable = true;
        waybar.enable = false;
        gtk.enable = false;
        kitty.enable = true;
        vesktop.enable = true;
        vscode.enable = true;
        xresources.enable = true;
        neovim.enable = true;
        firefox.enable = true;
        btop.enable = true;
      };
    };
  }];
}
