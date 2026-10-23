{ config, ... }:
let
  inherit (config.flake.modules) homeManager;
in
{
  flake.modules.nixos.desktop =
    { config, pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        libnotify
        wl-clipboard
      ];

      hardware.bluetooth.enable = true;

      home-manager.users.${config.owner.username}.imports = [ homeManager.desktop ];

      programs.appimage = {
        enable = true;
        binfmt = true;
      };
    };
}
