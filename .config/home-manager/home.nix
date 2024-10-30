{ config, pkgs, ... }:
{
  home.username = "USERNAME_PLACEHOLDER";
  home.homeDirectory = "/home/USERNAME_PLACEHOLDER";
  home.stateVersion = "24.05";
  home.packages = with pkgs; [
    delta
    dust
    eza
    fd
    ripgrep
    rsync
    sd
  ];

  imports = [
    ./apps/bat.nix
    ./apps/bottom.nix
    ./apps/direnv.nix
    ./apps/fzf.nix
    ./apps/git.nix
    ./apps/helix.nix
    ./apps/lazygit.nix
    ./apps/starship.nix
    ./apps/tmux.nix
    ./apps/yazi.nix
    ./apps/zoxide.nix
    ./apps/zsh.nix
  ];

  programs.home-manager.enable = true;
}
