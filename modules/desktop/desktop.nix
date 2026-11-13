{ config, ... }:
let
  homeManager = config.homeManager.modules;
in
{
  nixos.modules.desktop =
    { config, pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        libnotify
        wl-clipboard
      ];

      home-manager.users.${config.user.username}.imports = [ homeManager.desktop ];
    };

  # each app's file names the types it opens
  homeManager.modules.desktop.xdg.mimeApps.enable = true;
}
