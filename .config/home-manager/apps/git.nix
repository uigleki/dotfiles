{ userConfig, ... }: {
  programs.git = {
    enable = true;
    userName = userConfig.gitconfig.name;
    userEmail = userConfig.gitconfig.email;
    extraConfig = {
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only --features=interactive";
      delta.syntax-theme = "gruvbox-light";
      credential.helper = "store";
      pull.rebase = false;
    };
  };
}
