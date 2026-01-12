{
  config,
  pkgs,
  user,
  ...
}:
let
  isGui = config.myModules.gui.enable;
  package = if isGui then pkgs.gitFull else pkgs.git;
  helper = if isGui then "libsecret" else "store";
in
{
  programs = {
    git = {
      inherit package;
      enable = true;
      settings = {
        user = {
          name = user.gitName;
          email = user.gitEmail;
        };
        credential.helper = helper;
        init.defaultBranch = "main";
        log.date = "iso";
        pull.rebase = true;
        push.autoSetupRemote = true;
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
    };
  };
}
