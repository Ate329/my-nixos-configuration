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
    folder = /home/${username}/Pictures/Wallpapers
    wallpaper = /home/${username}/Pictures/Wallpapers/azusa_flower_crop.png
    # wallpaper = /home/${username}/Pictures/Wallpapers/richard-horvath-_nWaeTF6qo0-unsplash.png
    backend = hyprpaper
    monitors = All
    fill = Fill
    sort = name
    color = #f1eaff
    subfolders = False
    number_of_columns = 3
    post_command = 
    swww_transition_type = any
    swww_transition_step = 90
    swww_transition_angle = 0
    swww_transition_duration = 2
  '';
}
