{
  config,
  pkgs,
  inputs,
  username,
  host,
  ...
}:

{
  home.file.".config/hypr/hypridle.conf".text = ''
    general {
      lock_cmd = pidof hyprlock || hyprlock          # avoid starting multiple hyprlock instances.
      before_sleep_cmd = loginctl lock-session       # lock before suspend.
      after_sleep_cmd = hyprctl dispatch dpms on     # to avoid having to press a key twice to turn on the display.
    }

    listener {
      timeout = 300                                # 5min.
      on-timeout = brightnessctl -s set 10         # set monitor backlight to minimum, avoid 0 on OLED monitor.
      on-resume = brightnessctl -r                 # monitor backlight restore.
    }

    # turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
    listener { 
      timeout = 300                                                # 5min.
      on-timeout = brightnessctl -sd rgb:kbd_backlight set 0       # turn off keyboard backlight.
      on-resume = brightnessctl -rd rgb:kbd_backlight              # turn on keyboard backlight.
    }

    listener {
      timeout = 600                                 # 10min
      on-timeout = loginctl lock-session            # lock screen when timeout has passed
    }

    listener {
      timeout = 720                                 # 12min
      on-timeout = hyprctl dispatch dpms off        # screen off when timeout has passed
      on-resume = hyprctl dispatch dpms on          # screen on when activity is detected after timeout has fired.
    }

    listener {
      timeout = 900                                 # 15min
      on-timeout = systemctl suspend                # suspend pc
    }
  '';
}