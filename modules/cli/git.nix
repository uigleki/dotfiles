{ config, ... }:
let
  inherit (config) owner;
in
{
  flake.modules.homeManager = {
    base =
      { lib, ... }:
      {
        programs = {
          delta = {
            enable = true;
            enableGitIntegration = true;
            options.navigate = true;
          };

          git = {
            enable = true;

            ignores = [
              "**/.claude/settings.local.json"

              ".direnv"
              "/.pre-commit-config.yaml"
            ];

            lfs.enable = true;

            settings = {
              credential.helper = lib.mkDefault "store"; # plaintext; desktop uses the keyring
              init.defaultBranch = "main";
              log.date = "iso";
              merge.conflictStyle = "zdiff3";
              pull.rebase = true;
              push.autoSetupRemote = true;
              rebase.autoStash = true;

              user = {
                name = owner.gitName;
                email = owner.gitEmail;
              };
            };
          };

          lazygit = {
            enable = true;
            settings.git.pagers = [ { pager = "delta --paging=never"; } ];
            shellWrapperName = "g";
          };
        };
      };

    desktop =
      { pkgs, ... }:
      {
        programs.git = {
          package = pkgs.gitFull;
          settings.credential.helper = "libsecret";
        };
      };
  };
}
