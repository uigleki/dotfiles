{ inputs, ... }:
{
  imports = [ inputs.git-hooks.flakeModule ];

  perSystem =
    { config, pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        inputsFrom = [ config.pre-commit.devShell ];
        packages = [ pkgs.nixd ];
      };

      formatter = pkgs.nixfmt;

      pre-commit.settings = {
        hooks = {
          convco.enable = true;
          deadnix.enable = true;
          nil.enable = true;
          nixfmt.enable = true;
          statix.enable = true;
        };

        package = pkgs.prek; # rust pre-commit alternative
      };
    };
}
