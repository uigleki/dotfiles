{
  inputs,
  pkgs,
  user,
  ...
}:
{
  imports = [
    inputs.nix-index-database.homeModules.nix-index
    ./cli/aria2.nix
    ./cli/fzf.nix
    ./cli/git.nix
    ./cli/helix.nix
    ./cli/shell.nix
    ./cli/tmux.nix
  ];

  home = {
    stateVersion = user.stateVersion;

    packages = with pkgs; [
      delta
      dust
      fd
      just
      ouch
      rsync
      sd
    ];
  };

  programs = {
    bat.enable = true;
    bottom.enable = true;
    home-manager.enable = true;
    jujutsu.enable = true;
    nix-index-database.comma.enable = true;
    nix-index.enable = true;
    starship.enable = true;
    yazi.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
    };

    eza = {
      enable = true;
      extraOptions = [
        "--group-directories-first"
        "--time-style=iso"
      ];
    };

    nh = {
      enable = true;
      flake = user.flake;
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

  news.display = "silent";
}
