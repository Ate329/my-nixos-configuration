{
  pkgs,
  lib,
  inputs,
  ...
}:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in
{
  # allow spotify to be installed if you don't have unfree enabled already
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "spotify" ];

  programs.spicetify = {
    enable = true;
    # Commented due to the existence of stylix
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "macchiato";
    wayland = true;

    enabledExtensions = with spicePkgs.extensions; [
      adblock
      fullAppDisplay
      shuffle
      hidePodcasts
      beautifulLyrics
      copyLyrics
      volumePercentage
      betterGenres
      history
      copyToClipboard
      showQueueDuration
      songStats
      wikify
      fullAlbumDate
      groupSession
      goToSong
      playlistIntersection
    ];
  };
}
