{ config, pkgs, ... }: {
  home.username = "USERNAME_PLACEHOLDER";
  home.homeDirectory = "/home/USERNAME_PLACEHOLDER";
  home.stateVersion = "24.05";
  home.packages = with pkgs; [
    bottom
    eza
    git
    rsync
  ];

  imports = [
    ./apps/fzf.nix
    ./apps/helix.nix
    ./apps/ranger.nix
    ./apps/starship.nix
    ./apps/tmux.nix
    ./apps/zoxide.nix
    ./apps/zsh.nix
  ];

  programs.home-manager.enable = true;
}
