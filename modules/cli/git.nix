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
            lfs.enable = true;

            settings = {
              branch.sort = "-committerdate";
              column.ui = "auto";
              commit.verbose = true;
              credential.helper = lib.mkDefault "store"; # plaintext; desktop uses the keyring

              diff = {
                algorithm = "histogram";
                colorMoved = true;
              };

              fetch = {
                all = true;
                prune = true;
              };

              init.defaultBranch = "main";
              log.date = "iso";
              merge.conflictStyle = "zdiff3";
              pull.rebase = true;

              push = {
                autoSetupRemote = true;
                followTags = true;
              };

              rebase = {
                autoSquash = true;
                autoStash = true;
                updateRefs = true;
              };

              rerere.enabled = true;
              tag.sort = "version:refname";

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
