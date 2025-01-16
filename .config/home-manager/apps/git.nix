{ userConfig, ... }:
let
  gitconfig = userConfig.gitconfig or { };
  name = gitconfig.name or "";
  email = gitconfig.email or "";
in {
  programs.git = {
    enable = true;
    userName = name;
    userEmail = email;
    extraConfig = {
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only --features=interactive";
      delta.syntax-theme = "gruvbox-light";
      credential.helper = "store";
      pull.rebase = false;
    };
  };
}
