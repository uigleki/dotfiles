{ userConfig, ... }:
let
  name = userConfig.gitconfig.name or "";
  email = userConfig.gitconfig.email or "";
in {
  programs.git = {
    enable = true;
    userName = name;
    userEmail = email;
    delta = {
      enable = true;
      options = {
        navigate = true;
        syntax-theme = "gruvbox-light";
      };
    };
    extraConfig = {
      credential.helper = "store";
      pull.rebase = false;
    };
  };
}
