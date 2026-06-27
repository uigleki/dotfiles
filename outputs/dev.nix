{ inputs, ... }:
{
  imports = [ inputs.git-hooks.flakeModule ];

  perSystem =
    { config, pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        inputsFrom = [ config.pre-commit.devShell ];
        packages = with pkgs; [ nixd ];
      };

      formatter = pkgs.nixfmt;

      pre-commit.settings = {
        package = pkgs.prek; # rust pre-commit alternative
        hooks = {
          actionlint.enable = true;
          convco.enable = true;
          deadnix.enable = true;
          nil.enable = true;
          nixfmt.enable = true;
          ripsecrets.enable = true;
          statix.enable = true;
          typos.enable = true;
        };
      };
    };
}
