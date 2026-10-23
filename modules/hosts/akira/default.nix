{ config, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  configurations.nixos.akira.module =
    { config, ... }:
    {
      imports = [
        ./_hardware-configuration.nix
        nixos.base
        nixos.desktop
        nixos.disko-btrfs-luks
        nixos.lanzaboote
        nixos.network
        nixos.security
      ];

      boot.loader.timeout = 1;

      disko.devices.disk.main.device = "/dev/nvme0n1";

      hardware.nvidia = {
        open = true; # only set to false if older than RTX 20 series

        powerManagement = {
          enable = true; # preserve VRAM on suspend
          finegrained = true; # power off dGPU when idle
        };

        prime = {
          amdgpuBusId = "PCI:5:0:0";
          nvidiaBusId = "PCI:1:0:0";

          offload = {
            enable = true; # most games auto-use dGPU
            enableOffloadCmd = true;
          };
        };
      };

      home-manager.users.${config.owner.username}.programs.plasma.configFile = {
        kcminputrc."Libinput/1267/12474/ELAN1200:00 04F3:30BA Touchpad".DisableEventsOnExternalMouse = true;
      };

      nixpkgs.config.allowUnfreePackages = [
        "nvidia-settings"
        "nvidia-x11"
      ];

      services.xserver.videoDrivers = [ "nvidia" ];
    };
}
