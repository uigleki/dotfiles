{
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestion = {
      enable = true;
      strategy = [ "history" "completion" ];
    };
    shellAliases = {
      "d" = "yazi";
      "f" = "hx";
      "g" = "lazygit";
      "gcl" = "git clone --depth=1";
      "j" = "z";
      "k" = "btm";
      "l" = "eza -laF";
      "lt" = "eza -TF";
      "r" = "rsync";
      "t" = "tmux new -A";
      "u" = "nix flake update --flake ~/.config/home-manager && home-manager switch";
    };
    shellGlobalAliases.G = "| rg";
    sessionVariables.COLORTERM = "truecolor";
    dotDir = ".config/zsh";
    history = {
      ignoreAllDups = true;
      path = "$ZDOTDIR/.zsh_history";
    };
    initExtra = ''
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
      zstyle ':completion:*' list-colors ""
    '';
  };
}
