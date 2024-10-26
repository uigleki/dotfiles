{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      "f" = "hx";
      "j" = "z";
      "k" = "btm";
      "l" = "eza -laF";
      "lt" = "eza -TF";
      "r" = "rsync";
      "ra" = "ranger";
      "s" = "sudo";
      "t" = "tmux new -A";
      "u" = "nix flake update --flake ~/.config/home-manager && home-manager switch";
    };
  };
}
