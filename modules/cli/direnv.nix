{
  homeManager.modules.base.programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
    };

    git.ignores = [
      ".direnv/"
      # written by git-hooks.nix dev shells
      "/.pre-commit-config.yaml"
      # every dev shell runs rumdl
      ".rumdl_cache/"
    ];
  };
}
