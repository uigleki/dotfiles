{
  programs.fish = {
    enable = true;
    shellAbbrs = {
      d = "yazi";
      f = "hx";
      g = "lazygit";
      gcl = "git clone --depth=1";
      j = "z";
      k = "btm";
      l = "eza -laF";
      lt = "eza -TF";
      r = "rsync";
      t = "tmux new -A";
      u = "home-manager switch";
      uu =
        "nix flake update --flake ~/.config/home-manager && home-manager switch";
      G = {
        position = "anywhere";
        expansion = "| rg";
      };
    };
    interactiveShellInit = ''
      set fish_greeting
      set -gx COLORTERM truecolor
    '';
  };
}
