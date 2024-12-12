{
  programs.git = {
    enable = true;
    extraConfig = {
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only --features=interactive";
      delta.syntax-theme = "gruvbox-light";
      credential.helper = "store";
      pull.rebase = false;
    };
  };
}
