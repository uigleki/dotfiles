{ pkgs, userConfig, ... }:
let
  inherit (userConfig) username;
  extraPackages = map (name: pkgs.${name}) (userConfig.extra.packages or [ ]);
in {
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "24.05";
    packages = with pkgs; [ dust eza fd ripgrep rsync sd ] ++ extraPackages;
    sessionVariables = userConfig.env or { };
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
    ./apps/starship.nix
    ./apps/tealdeer.nix
    ./apps/tmux.nix
    ./apps/yazi.nix
    ./apps/zoxide.nix
    ./system/nix-cleanup.nix
  ];

  programs.home-manager.enable = true;
}
