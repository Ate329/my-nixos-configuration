{
  ...
}:

{
  languages.nix = {
    enable = true;
  };

  pre-commit = {
    hooks = {
      end-of-file-fixer.enable = true;
      trim-trailing-whitespace.enable = true;
      check-yaml.enable = true;
      check-json.enable = true;
      commitizen.enable = true;
      shellcheck.enable = true;
      nixfmt-rfc-style.enable = true;
    };
  };
}
