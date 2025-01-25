{
  pkgs,
  host,
  username,
  ...
}:
{
  programs.fish = {
    enable = true;
    package = pkgs.fish;
    shellAliases = {
      sv = "sudo nvim";
      flake-rebuild = "nh os switch --hostname ${host} /home/${username}/nix-config";
      flake-update = "nh os switch --hostname ${host} --update /home/${username}/nix-config";
      flake-rebuild-impure = "sudo nixos-rebuild switch --flake /home/${username}/nix-config#${host} --impure";
      gcCleanup = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
      v = "nvim";
      ls = "lsd";
      ll = "lsd -l";
      la = "lsd -a";
      lal = "lsd -al";
      ".." = "cd ..";
      neofetch = "neofetch --ascii ~/.config/ascii-neofetch";
      tsvpn = "tailscale up --accept-routes --exit-node=100.64.0.4 --login-server=https://headscale.ate329.nohost.me --accept-dns --operator=$USER";
      ssh = "kitten ssh";
    };

    shellInit = ''
      # Disable the default Fish greeting
      set fish_greeting

      # Display system information
      neofetch --ascii ~/.config/ascii-neofetch

      # Conditional execution example
      #if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
      #  exec Hyprland
      #end
    '';
  };

  environment.systemPackages = with pkgs; [
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.fzf
    fishPlugins.forgit
    fishPlugins.hydro
    fishPlugins.grc
    fishPlugins.z
    fishPlugins.tide
    fishPlugins.fifc
    fishPlugins.colored-man-pages
    fishPlugins.pisces
    fishPlugins.puffer
    grc
    fzf
  ];
}
