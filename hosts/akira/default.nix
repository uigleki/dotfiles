{ pkgs, user, ... }:
{
  home-manager.users.${user.name} = {
    home.packages = with pkgs; [
      claude-code
      ffmpeg
    ];
  };
}
