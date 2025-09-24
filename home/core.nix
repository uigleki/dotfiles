{
  inputs,
  pkgs,
  user,
  ...
}:
{
  imports = [
    inputs.nix-index-database.homeModules.nix-index
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
      fd
      rsync
    ];
  };

  programs = {
    bat.enable = true;
    bottom.enable = true;
    home-manager.enable = true;
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

    zoxide = {
      enable = true;
      options = [ "--cmd j" ];
    };
  };

  news.display = "silent";
}
