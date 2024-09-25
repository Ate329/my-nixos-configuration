{ pkgs, config, ... }:

{
  # Fcitx5 theme configuration
  xdg.configFile."fcitx5/conf/classicui.conf".text = ''
    Theme=rose-pine-moon
  '';

  # Rime configuration for page size
  home.file.".local/share/fcitx5/rime/default.custom.yaml".text = ''
    patch:
      menu/page_size: 9
  '';
}
