{ inputs, ... }:
{
  imports = [ inputs.git-hooks.flakeModule ];

  perSystem =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      devShells.default = config.pre-commit.devShell;

      formatter = pkgs.nixfmt;

      pre-commit = {
        check.enable = true;
        settings = {
          hooks = lib.genAttrs [ "convco" "deadnix" "nil" "nixfmt" "statix" ] (_: {
            enable = true;
          });
          package = pkgs.prek; # rust pre-commit alternative
        };
      };
    };
}
