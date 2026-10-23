{ config, ... }:
let
  inherit (config) owner;
in
{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      programs.git = {
        package = pkgs.gitFull;
        settings.credential.helper = "libsecret";
      };
    };

  flake.modules.homeManager.base =
    { lib, ... }:
    {
      programs = {
        git = {
          enable = true;
          lfs.enable = true;

          settings = {
            user = {
              name = owner.gitName;
              email = owner.gitEmail;
            };

            credential.helper = lib.mkDefault "store"; # plaintext; desktop uses the keyring
            init.defaultBranch = "main";
            log.date = "iso";
            merge.conflictStyle = "zdiff3";
            pull.rebase = true;
            push.autoSetupRemote = true;
            rebase.autoStash = true;
          };
        };

        delta = {
          enable = true;
          enableGitIntegration = true;
          options.navigate = true;
        };

        lazygit = {
          enable = true;
          settings.git.pagers = [ { pager = "delta --paging=never"; } ];
          shellWrapperName = "g";
        };
      };
    };
}
