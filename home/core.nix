{
  pkgs,
  ...
}:
{
  imports = [
    ./cli/aria2.nix
    ./cli/fzf.nix
    ./cli/git.nix
    ./cli/helix.nix
    ./cli/shell.nix
    ./cli/tmux.nix
  ];

  home = {
    stateVersion = "24.05";

    packages = with pkgs; [
      delta
      dust
      eza
      fd
      p7zip
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

  news.display = "silent";
}
