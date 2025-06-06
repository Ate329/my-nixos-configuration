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
      tsvpn = "tailscale up --accept-routes --exit-node=yunohost-homelab --accept-dns --exit-node-allow-lan-access=true --operator=$USER";
      ssh = "kitten ssh";
    };

    shellInit = ''
      # Disable the default Fish greeting
      set fish_greeting
    '';

    interactiveShellInit = ''
      neofetch --ascii ~/.config/ascii-neofetch

      # Initialize starship with our custom configuration
      starship init fish | source
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
    fish-lsp
    starship
  ];
}
