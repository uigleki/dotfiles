{ config, pkgs, ... }: {
  home.username = "USERNAME_PLACEHOLDER";
  home.homeDirectory = "/home/USERNAME_PLACEHOLDER";
  home.stateVersion = "24.05";
  home.packages = with pkgs; [
    bat
    bottom
    delta
    dust
    eza
    fd
    git
    ripgrep
    rsync
    sd
  ];

  imports = [
    ./apps/helix.nix
    ./apps/lazygit.nix
    ./apps/skim.nix
    ./apps/starship.nix
    ./apps/tmux.nix
    ./apps/yazi.nix
    ./apps/zoxide.nix
    ./apps/zsh.nix
  ];

  programs.home-manager.enable = true;
}
