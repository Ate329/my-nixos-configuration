{
  pkgs,
  host,
  username,
  ...
}:

pkgs.writeShellScriptBin "themechange" ''
  if [[ ! $@ ]];then
    echo "No Theme Given"
  else
    replacement="$1"
    sed -i "/^\s*theme[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$replacement\"/" /home/${username}/nix-config/hosts/${host}/variables.nix
    kitty -e pkexec nixos-rebuild switch --flake /home/${username}/nix-config
  fi
''
