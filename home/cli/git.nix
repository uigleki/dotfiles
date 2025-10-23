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

    lazygit = {
      enable = true;
      settings.git.paging = {
        colorArg = "always";
        pager = "delta --paging=never";
      };
    };

    delta = {
      enable = true;
      enableGitIntegration = true;
      options.navigate = true;
    };
  };
}
