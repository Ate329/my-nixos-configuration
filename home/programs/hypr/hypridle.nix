{
  config,
  pkgs,
  inputs,
  username,
  host,
  ...
}:

{
  home.file.".config/hypr/hypridle-ac.conf".text = ''
    general {
        lock_cmd = pidof hyprlock || hyprlock
        before_sleep_cmd = loginctl lock-session
        after_sleep_cmd = hyprctl dispatch dpms on
    }

    listener {
        timeout = 360
        on-timeout = brightnessctl -s set 10
        on-resume = brightnessctl -r
    }

    listener {
        timeout = 360
        on-timeout = brightnessctl -sd rgb:kbd_backlight set 0
        on-resume = brightnessctl -rd rgb:kbd_backlight
    }

    listener {
        timeout = 720
        on-timeout = loginctl lock-session
    }
  '';

  home.file.".config/hypr/hypridle-battery.conf".text = ''
    general {
      lock_cmd = pidof hyprlock || hyprlock
      before_sleep_cmd = loginctl lock-session
      after_sleep_cmd = hyprctl dispatch dpms on
    }

    listener {
      timeout = 180
      on-timeout = brightnessctl -s set 10
      on-resume = brightnessctl -r
    }

    listener {
      timeout = 180
      on-timeout = brightnessctl -sd rgb:kbd_backlight set 0
      on-resume = brightnessctl -rd rgb:kbd_backlight
    }

    listener {
      timeout = 300
      on-timeout = loginctl lock-session
    }

    listener {
      timeout = 480
      on-timeout = hyprctl dispatch dpms off
      on-resume = hyprctl dispatch dpms on
    }

    listener {
      timeout = 600
      on-timeout = systemctl suspend
    }
  '';
}
