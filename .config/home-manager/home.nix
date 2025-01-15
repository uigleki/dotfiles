{ pkgs, userConfig, ... }:
let username = builtins.getEnv "USER";
in {
  home = {
    username = username;
    homeDirectory = "/home/" + username;
    stateVersion = "24.05";
    packages = with pkgs; [ delta dust eza fd ripgrep rsync sd ];
  };

  imports = [
    ./apps/bash.nix
    ./apps/bat.nix
    ./apps/bottom.nix
    ./apps/direnv.nix
    ./apps/fish.nix
    ./apps/fzf.nix
    ./apps/git.nix
    ./apps/helix.nix
    ./apps/lazygit.nix
    ./apps/starship.nix
    ./apps/tmux.nix
    ./apps/yazi.nix
    ./apps/zoxide.nix
    ./envs.nix
    (import ./envs.nix { inherit userConfig; })
  ];

  programs.home-manager.enable = true;
}
