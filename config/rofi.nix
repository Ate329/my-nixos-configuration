{ pkgs, config, ... }:

let
  palette = config.colorScheme.palette;

in {
  home.file.".config/rofi/config.rasi".text = ''
    @theme "/dev/null"

    * {
      bg: #${palette.base00};
      background-color: @bg;
    }

    configuration {
      modi: "run,filebrowser,drun";
      show-icons: true;
      icon-theme: "Papirus";
      location: 0;
      font: "JetBrains Nerd Font 14";	
      drun-display-format: "{icon} {name}";
      display-drun: "   Apps ";
      display-run: "   Run ";
      display-filebrowser: "   File ";
    }

    window { 
      width: 35%;
      transparency: "real";
      orientation: vertical;
      border: 1px;
      border-color: #${palette.base0F};
      border-radius: 7px;
    }

    mainbox {
      children: [ inputbar, listview, mode-switcher ];
    }

    element {
      padding: 6 12;
      text-color: #${palette.base05};
      border-radius: 4px;
    }

    element selected {
      text-color: #${palette.base01};
      background-color: #${palette.base0C};
    }

    element-text {
      background-color: inherit;
      text-color: inherit;
    }

    element-icon {
      size: 20px;
      background-color: inherit;
      padding: 0 5 0 0;
      alignment: vertical;
    }

    listview {
      columns: 1;
      lines: 7;
      padding: 6 0;
      fixed-height: true;
      fixed-columns: true;
      fixed-lines: true;
      border: 0 7 5 7;
    }

    entry {
      text-color: #${palette.base05};
      padding: 8 8 0 0;
      margin: 0 -1 0 0;
    }

    inputbar {
      background-image: url("~/zaneyos/config/rofi.jpg", width);
      padding: 120 0 0;
      margin: 0 0 0 0;
    } 

    prompt {
      text-color: #${palette.base0D};
      padding: 8 5 0 8;
      margin: 0 -1 0 0;
    }

    mode-switcher {
      border-color: #${palette.base0F};
      spacing: 0;
    }

    button {
      padding: 8px;
      background-color: @bg;
      text-color: #${palette.base01};
      vertical-align: 0.5; 
      horizontal-align: 0.5;
    }

    button selected {
      background-color: @bg;
      text-color: #${palette.base0F};
    }

    message {
      background-color: @bg;
      margin: 1px;
      padding: 1px;
      border-radius: 4px;
    }

    textbox {
      padding: 4px;
      margin: 15px 0px 0px 15px;
      text-color: #${palette.base0F};
      background-color: @bg;
    }
  '';
}
