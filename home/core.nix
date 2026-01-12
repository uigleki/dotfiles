{
  inputs,
  pkgs,
  user,
  ...
}:
{
  imports = with inputs; [
    catppuccin.homeModules.catppuccin
    nix-index-database.homeModules.nix-index
    plasma-manager.homeModules.plasma-manager
    ./cli/fzf.nix
    ./cli/git.nix
    ./cli/helix.nix
    ./cli/shell.nix
    ./cli/tmux.nix
  ];

  home = {
    inherit (user) stateVersion;

    packages = with pkgs; [
      ouch
      rsync
    ];

    sessionVariables = {
      COLORTERM = "truecolor";
    };
  };

  catppuccin = {
    enable = true;
    flavor = "latte";
    cache.enable = true;
  };

  programs = {
    bat.enable = true;
    bottom.enable = true;
    fd.enable = true;
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
      inherit (user) flake;
      enable = true;
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
}
