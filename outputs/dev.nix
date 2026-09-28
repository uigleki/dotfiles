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
          nixfmt.enable = true;
          statix.enable = true;
          typos.enable = true;

          betterleaks = {
            enable = true;
            package = pkgs.betterleaks;
            # Scans the files it is given; the official `git --staged` would ignore them.
            entry = "${lib.getExe pkgs.betterleaks} dir --redact --no-banner --verbose";
            types = [ "text" ];
          };

          nil = {
            enable = true;
            settings.denyWarnings = true;
          };

          rumdl = {
            enable = true;
            args = [ "--fix" ];
          };

          tombi = {
            enable = true;
            package = pkgs.tombi;
            entry = "${lib.getExe pkgs.tombi} format --offline";
            # Not `types = [ "toml" ]`: Cargo.lock is tagged toml too.
            files = "\\.toml$";
          };

          yamlfmt = {
            enable = true;
            settings.lint-only = false;
          };
        };
      };
    };
}
