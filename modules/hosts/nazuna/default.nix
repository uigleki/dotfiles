{ config, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  configurations.nixos.nazuna.module =
    { config, ... }:
    {
      imports = [
        ./_hardware-configuration.nix
        nixos.auto-upgrade
        nixos.base
        nixos.disko-btrfs
        nixos.network
        nixos.security
        nixos.server
        nixos.systemd-boot
      ];

      boot = {
        binfmt.emulatedSystems = [ "x86_64-linux" ]; # run x86 binaries on ARM
        loader.timeout = 0;
      };

      disko.devices.disk.main.device = "/dev/sda";

      # expose syncthing GUI for remote access
      home-manager.users.${config.owner.username}.services.syncthing.guiAddress = "0.0.0.0:8384";
    };
}
