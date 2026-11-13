{ config, ... }:
let
  nazuna = config.flake.nixosConfigurations.nazuna.config;
  nixos = config.nixos.modules;
in
{
  flake.deploy.nodes.nazuna = {
    hostname = nazuna.networking.hostName;

    profiles.system = {
      path = nazuna.system.build.toplevel;
      remoteBuild = true; # the desktop cannot build aarch64
      sshUser = nazuna.user.username;
      user = "root";
    };
  };

  nixos.configurations.nazuna.module =
    { config, ... }:
    {
      imports = [
        ./_hardware-configuration.nix
        nixos.auto-upgrade
        nixos.disko-btrfs
        nixos.impermanence
        nixos.server
        nixos.systemd-boot
      ];

      boot = {
        binfmt.emulatedSystems = [ "x86_64-linux" ]; # run x86 binaries on ARM
        loader.timeout = 0;
      };

      disko.devices.disk.main.device = "/dev/sda";

      # expose syncthing GUI for remote access
      home-manager.users.${config.user.username}.services.syncthing.guiAddress = "0.0.0.0:8384";
    };
}
