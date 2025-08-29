{
  lib,
  pkgs,
  userConfig,
  ...
}:
let
  inherit (userConfig) username;
  extraPackages = map (name: pkgs.${name}) (userConfig.extra.packages or [ ]);
  optionalFile = path: lib.optional (builtins.pathExists path) path;
in
{
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "24.05";
    packages =
      with pkgs;
      [
        delta
        dust
        eza
        fd
        rsync
        sd
      ]
      ++ extraPackages;
    sessionVariables = userConfig.env or { };
  };

  programs = {
    home-manager.enable = true;
    nix-your-shell.enable = true;
    starship.enable = true;
    yazi.enable = true;
  };

  imports = [
    ../modules/cli/aria2.nix
    ../modules/cli/bash.nix
    ../modules/cli/bat.nix
    ../modules/cli/bottom.nix
    ../modules/cli/direnv.nix
    ../modules/cli/fish.nix
    ../modules/cli/fzf.nix
    ../modules/cli/git.nix
    ../modules/cli/helix.nix
    ../modules/cli/lazygit.nix
    ../modules/cli/nix.nix
    ../modules/cli/ripgrep.nix
    ../modules/cli/tealdeer.nix
    ../modules/cli/tmux.nix
    ../modules/cli/zoxide.nix
  ]
  ++ optionalFile ../extra.nix;

  news.display = "silent";
}
