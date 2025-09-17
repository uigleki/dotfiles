{ pkgs, user, ... }:
{
  imports = [ ../../nixos/wsl.nix ];

  home-manager.users.${user.name} = {
    home.packages = with pkgs; [
      claude-code
      ffmpeg
    ];
  };
}
