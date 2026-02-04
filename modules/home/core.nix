{
  inputs,
  pkgs,
  user,
  ...
}:
{
  imports = [
    inputs.nix-index-database.homeModules.nix-index
    ./fzf.nix
    ./git.nix
    ./helix.nix
    ./shell.nix
    ./tmux.nix
  ];

  home = {
    inherit (user) stateVersion;

    packages = with pkgs; [ rsync ];

    sessionVariables = {
      COLORTERM = "truecolor";
    };
  };

  programs = {
    bat.enable = true;
    bottom.enable = true;
    fd.enable = true;
    nix-index-database.comma.enable = true; # run uninstalled commands: , <cmd>
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
      options = [ "--cmd j" ]; # use j instead of default z
    };
  };
}
