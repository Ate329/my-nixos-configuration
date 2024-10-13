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
    autoEnable = true;

    targets = {
      grub = {
        enable = false;
        useImage = false;
      };
      gtk.enable = false;
    };

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
        popups = 13;
      };
    };
  };
  home-manager.sharedModules = [{
    stylix = {
      targets = {
        rofi.enable = false;
        waybar.enable = false;
        gtk.enable = false;
      };
    };
  }];
}
