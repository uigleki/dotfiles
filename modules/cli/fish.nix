{ userConfig, ... }: {
  programs.fish = {
    enable = true;
    shellAbbrs = {
      bt = "aria2c --bt-tracker=(curl -fsSL https://trackerslist.com/all_aria2.txt)";
      d = "yazi";
      dl = "aria2c";
      f = "hx";
      g = "lazygit";
      gcl = "git clone --depth=1";
      gp = "git pull";
      k = "btm";
      l = "eza -laF";
      lt = "eza -TF";
      r = "rsync -rthP";
      t = "tmux new -A";
      u = "home-manager switch";
      uu =
        "nix flake update --flake ~/.config/home-manager && home-manager switch";
      G = {
        position = "anywhere";
        expansion = "| rg";
      };
    } // (userConfig.abbr or { });
    interactiveShellInit = ''
      set fish_greeting
      set -gx COLORTERM truecolor

      set secret "$HOME/.secrets/env"
      if test -f "$secret"
        source "$secret"
      end
    '';
  };
}
