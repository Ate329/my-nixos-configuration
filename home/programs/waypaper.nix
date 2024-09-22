{
  config,
  pkgs,
  username,
  ...
}:

{
  home.file.".config/waypaper/config.ini".text = ''
    [Settings]
    language = en
    folder = /home/${username}/nix-config/home/themes/wallpapers
    wallpaper = /home/${username}/nix-config/home/themes/wallpapers/azusa_flower_crop.png
    # wallpaper = /home/${username}/nix-config/home/themes/wallpapers/richard-horvath-_nWaeTF6qo0-unsplash.png
    backend = swaybg
    monitors = All
    fill = Fill
    sort = name
    color = #f1eaff
    subfolders = False
    number_of_columns = 3
    post_command =
    show_hidden = False
    show_gifs_only = False
    swww_transition_type = any
    swww_transition_step = 90
    swww_transition_angle = 0
    swww_transition_duration = 2
    use_xdg_state = False
  '';
}
