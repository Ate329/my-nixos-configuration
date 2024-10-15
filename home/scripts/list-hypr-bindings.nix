{ pkgs, host, ... }:

let
  inherit (import ../../hosts/${host}/variables.nix) terminal browser;
in
pkgs.writeShellScriptBin "list-hypr-bindings" ''
  yad --width=800 --height=500 \
  --center \
  --fixed \
  --title="Hyprland Keybindings" \
  --no-buttons \
  --list \
  --column=Key: \
  --column=Description: \
  --column=Command: \
  --timeout=30 \
  --timeout-indicator=top \
  "  = Windows/Super" "Modifier Key, used for keybindings" "Doesn't really execute anything by itself." \
  "  + B" "Launch this key bindings window" "list-hypr-bindings" \
  "  + Q" "Launch Terminal" "${terminal}" \
  "  + SHIFT + Return" "Rofi App Launcher" "rofi-launcher" \
  "  + W" "Launch Web Browser" "${browser}" \
  "  + O" "Launch OBS" "obs" \
  "  + G" "Launch GIMP" "gimp" \
  "  + T" "Launch File Browser" "thunar" \
  "  + S" "Launch Spotify" "spotify" \
  "  + Z" "Launch Zeditor" "zeditor" \
  "  + L" "Launch Wlogout" "wlogout" \
  "  + SHIFT + C" "Quit / Exit Hyprland" "exit" \
  "  + SHIFT + N" "Reload SwayNC Styling" "swaync-client -rs" \
  "  + E" "Kill Focused Window" "killactive" \
  "  + P" "Pseudo Tiling" "pseudo" \
  "  + SHIFT + I" "Toggle Split Direction" "togglesplit" \
  "  + F" "Toggle Focused Fullscreen" "fullscreen" \
  "  + SHIFT + F" "Toggle Focused Floating" "togglefloating" \
  "  + Left" "Move Focus To Window On The Left" "movefocus,l" \
  "  + Right" "Move Focus To Window On The Right" "movefocus,r" \
  "  + Up" "Move Focus To Window On The Up" "movefocus,u" \
  "  + Down" "Move Focus To Window On The Down" "movefocus,d" \
  "  + SHIFT + H" "Move Focused Window Left" "movewindow,l" \
  "  + SHIFT + L" "Move Focused Window Right" "movewindow,r" \
  "  + SHIFT + K" "Move Focused Window Up" "movewindow,u" \
  "  + SHIFT + J" "Move Focused Window Down" "movewindow,d" \
  "  + Semicolon" "Decrease Split Ratio" "splitratio,-0.1" \
  "  + Apostrophe" "Increase Split Ratio" "splitratio,0.1" \
  "  + 1-0" "Switch to Workspace 1-10" "workspace-switcher 1-10" \
  "  + SHIFT + 1-0" "Move Focused Window To Workspace 1-10" "movetoworkspace,1-10" \
  "  + ALT + 1-0" "Move Focused Window To Workspace 11-20" "movetoworkspace,11-20" \
  "  + CONTROL + Left" "Switch to Left Workspace" "workspace-switcher switch left" \
  "  + CONTROL + Right" "Switch to Right Workspace" "workspace-switcher switch right" \
  "  + CONTROL_SHIFT + Left" "Move Workspace Left" "workspace-switcher move left" \
  "  + CONTROL_SHIFT + Right" "Move Workspace Right" "workspace-switcher move right" \
  "  + SHIFT + Up" "Switch to Previous Workspace Group" "workspace,-10" \
  "  + SHIFT + Down" "Switch to Next Workspace Group" "workspace,+10" \
  "  + CONTROL + Right" "Switch to Next Workspace" "workspace,e+1" \
  "  + CONTROL + Left" "Switch to Previous Workspace" "workspace,e-1" \
  "  + SHIFT + Left" "Switch to Previous Workspace" "workspace,-1" \
  "  + SHIFT + Right" "Switch to Next Workspace" "workspace,+1" \
  "  + SPACE" "Toggle Special Workspace" "togglespecialworkspace" \
  "  + SHIFT + SPACE" "Move Focused Window To Special Workspace" "movetoworkspace,special" \
  "  + M" "Move Workspace to Current Monitor" "moveworkspacetomonitor,1 current" \
  "  + SHIFT + W" "Search Websites" "web-search" \
  "  + ALT + W" "Set Wallpaper" "wallsetter" \
  "  + SHIFT + E" "Launch Emoji Picker" "emopicker9000" \
  "  + SHIFT + S" "Take Screenshot (Selected Area)" "slurp" \
  "  + V" "Clipboard History" "cliphist list | rofi -dmenu | cliphist decode | wl-copy" \
  "ALT + TAB" "Toggle Workspace Overview" "hyprexpo:expo,toggle" \
  "  + TAB" "Toggle Overview" "hyprctl dispatch overview:toggle" \
  "  + SHIFT + TAB" "Toggle Overview (All Workspaces)" "hyprctl dispatch overview:toggle all" \
  "  + M" "Launch System Monitor" "kitty btop" \
  "  + CONTROL + SHIFT + S" "OCR: Copy Text from Screen" "slurp + OCR" \
  "  + SHIFT + T" "OCR: Copy English Text from Screen" "slurp + OCR" \
  "  + SHIFT + J" "OCR: Copy Japanese Text from Screen" "slurp + OCR" \
  "  + MOUSE_LEFT" "Move/Drag Window" "movewindow" \
  "  + MOUSE_RIGHT" "Resize Window" "resizewindow" \
  ""
''
