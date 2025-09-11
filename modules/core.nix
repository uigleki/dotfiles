{
  pkgs,
  lib,
  user,
  hostname,
  isNixOS,
  ...
}:
{
  imports = [
    ./programs/aria2.nix
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/helix.nix
    ./programs/shell.nix
    ./programs/tmux.nix
  ];

  home = {
    stateVersion = "24.05";

    packages = with pkgs; [
      delta
      dust
      eza
      fd
      rsync
      sd
    ];
  };

  programs = {
    home-manager.enable = true;
    nix-your-shell.enable = true;
    starship.enable = true;
    yazi.enable = true;

    bat = {
      enable = true;
      config.theme = "gruvbox-light";
    };

    bottom = {
      enable = true;
      settings.flags.color = "gruvbox-light";
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
    };

    ripgrep = {
      enable = true;
      arguments = [ "--smart-case" ];
    };

    tealdeer = {
      enable = true;
      settings.updates.auto_update = true;
    };

    zoxide = {
      enable = true;
      options = [ "--cmd j" ];
    };
  };

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };

  news.display = "silent";
}
