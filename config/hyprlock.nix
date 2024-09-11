{
  pkgs,
  config,
  lib,
  inputs,
  username,
  host,
  ...
}:

{
  home.file.".config/hypr/hyprlock.conf".text = ''
    $text_color = rgba(DFE3E7FF)
    $entry_background_color = rgb(93, 141, 212)
    $entry_border_color = rgb(139, 146, 151)
    $entry_color = rgb(193, 199, 206)
    $font_family = JetBrainsMono Nerd Font
    $font_family_clock = JetBrainsMono Nerd Font
    $font_material_symbols = Material Symbols Rounded

    text_trim = false

    background {
        color = rgba(0F141777)
        # path = {{ SWWW_WALL }}
        path = /home/${username}/nix-config/config/hyprlock.jpg
        blur_size = 5
        blur_passes = 4
    }

    input-field {
        monitor =
        size = 500, 100
        outline_thickness = 2
        dots_size = 0.1
        dots_spacing = 0.3
        outer_color = $entry_border_color
        inner_color = $entry_background_color
        font_color = $entry_color
        # fade_on_empty = true

        position = 0, -20
        halign = center
        valign = center
    }

    label { # Clock
        monitor =
        text = $TIME
        shadow_passes = 1
        shadow_boost = 0.5
        color = $text_color
        font_size = 130
        font_family = $font_family_clock

        position = 0, 300
        halign = center
        valign = center
    }
    label { # Greeting
        monitor =
        text = Hi $USER
        shadow_passes = 1
        shadow_boost = 0.5
        color = $text_color
        font_size = 40
        font_family = $font_family

        position = 0, 145
        halign = center
        valign = center
    }
    label { # lock icon
        monitor =
        text =       
        shadow_passes = 1
        shadow_boost = 0.5
        color = $text_color
        font_size = 45
        font_family = $font_material_symbols

        position = 0, 51
        halign = center
        valign = bottom
    }

    label { # "locked" text
        monitor =
        text = 
        shadow_passes = 1
        shadow_boost = 0.5
        color = $text_color
        font_size = 28
        font_family = $font_family

        position = 0, 10
        halign = center
        valign = bottom
    }

    label { # Status
        monitor =
        text = cmd[update:5000] /home/${username}/nix-config/config/hyprlock/status.sh
        shadow_passes = 1
        shadow_boost = 0.5
        color = $text_color
        font_size = 28
        font_family = $font_family

        position = 30, -30
        halign = left
        valign = top
    }
  '';
}
