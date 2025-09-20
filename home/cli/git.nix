{ user, ... }:
{
  programs = {
    git = {
      enable = true;
      userName = user.gitName;
      userEmail = user.gitEmail;
      delta = {
        enable = true;
        options.navigate = true;
      };
      extraConfig = {
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
  };
}
