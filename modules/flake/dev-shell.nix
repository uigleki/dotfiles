{
  perSystem =
    { config, pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        inputsFrom = [ config.pre-commit.devShell ];
        packages = with pkgs; [
          deploy-rs
          nixd
        ];

        shellHook = ''
          # git-hooks.nix sets core.hooksPath to .git/hooks, so linked worktrees skip every hook.
          git config --local --unset-all core.hooksPath || true
        '';
      };

      formatter = pkgs.nixfmt-tree;
    };
}
