{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
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
      "u" = "nix flake update --flake ~/.config/home-manager && home-manager switch && nix store gc";
    };
    shellGlobalAliases.G = "| rg";
    sessionVariables.COLORTERM = "truecolor";
  };
}
