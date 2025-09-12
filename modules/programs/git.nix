{ user, ... }:
{
  programs = {
    git = {
      enable = true;
      userName = user.userName;
      userEmail = user.userEmail;
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
