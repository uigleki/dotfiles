{ pkgs, userConfig, ... }:
let
  inherit (userConfig) username;
  extraPackages = map (name: pkgs.${name}) (userConfig.extra.packages or [ ]);
in {
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "24.05";
    packages = with pkgs; [ delta dust eza fd rsync sd ] ++ extraPackages;
    sessionVariables = userConfig.env or { };
  };

  programs = {
    home-manager.enable = true;
    nix-your-shell.enable = true;
    starship.enable = true;
    yazi.enable = true;
  };

  imports = [
    ./apps/aria2.nix
    ./apps/bash.nix
    ./apps/bat.nix
    ./apps/bottom.nix
    ./apps/direnv.nix
    ./apps/fish.nix
    ./apps/fzf.nix
    ./apps/git.nix
    ./apps/helix.nix
    ./apps/lazygit.nix
    ./apps/nix.nix
    ./apps/ripgrep.nix
    ./apps/tealdeer.nix
    ./apps/tmux.nix
    ./apps/zoxide.nix
  ];

  news.display = "silent";
}
