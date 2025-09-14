{ user, ... }:
{
  programs = {
    git = {
      enable = true;
      userName = user.gitName;
      userEmail = user.gitEmail;
      delta = {
        enable = true;
        options = {
          navigate = true;
          syntax-theme = "gruvbox-light";
        };
      };
      extraConfig = {
        init.defaultBranch = "main";
        credential.helper = "store";
        pull.rebase = false;
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
