{
  config,
  inputs,
  lib,
  pkgs,
  user,
  ...
}:
let
  inherit (config.home) homeDirectory;
in
{
  imports = [
    inputs.nix-index-database.homeModules.nix-index
    ./claude.nix
    ./fzf.nix
    ./git.nix
    ./helix.nix
    ./opencode.nix
    ./shell.nix
    ./tmux.nix
  ];

  home = {
    inherit (user) stateVersion;
    file.".local/bin/node".source = lib.getExe pkgs.bun;

    packages = with pkgs; [
      _7zz
      mutagen
      rsync
      unar
      unstable.codex
    ];

    sessionPath = [
      "${homeDirectory}/.bun/bin"
      "${homeDirectory}/.local/bin"
    ];

    sessionVariables = {
      COLORTERM = "truecolor";
    };
  };

  programs = {
    bat.enable = true;
    bottom.enable = true;
    bun.enable = true;
    fd.enable = true;
    gh.enable = true;
    nix-index-database.comma.enable = true; # run uninstalled commands: , <cmd>
    nix-index.enable = true;
    starship.enable = true;
    uv.enable = true;
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
