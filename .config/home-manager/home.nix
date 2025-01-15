{ pkgs, userConfig, ... }: {
  home = {
    username = "USERNAME_PLACEHOLDER";
    homeDirectory = "/home/USERNAME_PLACEHOLDER";
    stateVersion = "24.05";
    packages = with pkgs; [ delta dust eza fd ripgrep rsync sd ];
  };

  imports = [
    (import ./apps/git.nix { inherit userConfig; })
    (import ./envs.nix { inherit userConfig; })
    ./apps/bash.nix
    ./apps/bat.nix
    ./apps/bottom.nix
    ./apps/direnv.nix
    ./apps/fish.nix
    ./apps/fzf.nix
    ./apps/helix.nix
    ./apps/lazygit.nix
    ./apps/starship.nix
    ./apps/tmux.nix
    ./apps/yazi.nix
    ./apps/zoxide.nix
  ];

  programs.home-manager.enable = true;
}
