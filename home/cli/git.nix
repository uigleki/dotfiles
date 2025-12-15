{ user, ... }:
{
  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name = user.gitName;
          email = user.gitEmail;
        };
        credential.helper = "store";
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
