{ pkgs, userConfig, ... }:
let
  inherit (userConfig) username;
  extraPackages = map (name: pkgs.${name}) (userConfig.extra.packages or [ ]);
in {
  news.display = "silent";
  programs.home-manager.enable = true;

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "24.05";
    packages = with pkgs; [ delta dust eza fd rsync sd ] ++ extraPackages;
    sessionVariables = userConfig.env or { };
  };

  nix.gc = {
    automatic = true;
    frequency = "weekly";
    options = "--delete-older-than 30d";
    persistent = true;
    randomizedDelaySec = "1min";
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
    ./apps/ripgrep.nix
    ./apps/starship.nix
    ./apps/tealdeer.nix
    ./apps/tmux.nix
    ./apps/yazi.nix
    ./apps/zoxide.nix
  ];
}
