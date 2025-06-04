{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs_kernel_src.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    hyprswitch.url = "github:H3rmt/hyprswitch/old-release-hyprswitch";
    catppuccin.url = "github:catppuccin/nix";

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    Hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };

    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    grub2-themes = {
      url = "github:vinceliuice/grub2-themes";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    oskars-dotfiles = {
      url = "github:oskardotglobal/.dotfiles/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      nixpkgs_kernel_src,
      home-manager,
      auto-cpufreq,
      grub2-themes,
      spicetify-nix,
      oskars-dotfiles,
      catppuccin,
      stylix,
      nix-flatpak,
      ...
    }:
    let
      system = "x86_64-linux";
      host = "nixos";
      username = "ate329";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      nixosConfigurations = {
        "${host}" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system;
            inherit inputs;
            inherit username;
            inherit host;
            pkgs_kernel_src = import nixpkgs_kernel_src {
              inherit system;
              config.allowUnfree = true;
            };
          };
          modules = [
            ./hosts/${host}/config.nix
            home-manager.nixosModules.home-manager
            grub2-themes.nixosModules.default
            auto-cpufreq.nixosModules.default
            catppuccin.nixosModules.catppuccin
            inputs.stylix.nixosModules.stylix
            nix-flatpak.nixosModules.nix-flatpak

            (
              { pkgs, ... }:
              {
                nixpkgs.overlays = [ oskars-dotfiles.overlays.spotx ];
                environment.systemPackages = [ pkgs.spotify ];
              }
            )

            {
              home-manager.extraSpecialArgs = {
                inherit username;
                inherit inputs;
                inherit host;
                pkgs_kernel_src = import nixpkgs_kernel_src {
                  inherit system;
                  config.allowUnfree = true;
                };
              };
              home-manager.useGlobalPkgs = false;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.${username} = import ./hosts/${host}/home.nix;
            }
          ];
        };
      };
    };
}
