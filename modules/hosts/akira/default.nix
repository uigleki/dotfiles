{ config, ... }:
let
  nixos = config.nixos.modules;
in
{
  nixos.configurations.akira =
    { config, ... }:
    {
      imports = [
        ./_hardware-configuration.nix
        nixos.desktop
        nixos.disko-btrfs-luks
        nixos.impermanence
        nixos.snapshots
        nixos.tpm-unlock
      ];

      boot.loader.timeout = 1;
      disko.devices.disk.main.device = "/dev/nvme0n1";

      hardware.nvidia = {
        open = true; # only set to false if older than RTX 20 series

        powerManagement = {
          enable = true;
          finegrained = true;
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

      home-manager.users.${config.user.username}.home.persistence."/persist" = {
        directories = [ ".config/systemd" ]; # hand-written user units and whether they are enabled
        files = [ ".nvidia-settings-rc" ];
      };

      nixpkgs.config.allowUnfreePackages = [
        "nvidia-settings"
        "nvidia-x11"
      ];

      services.xserver.videoDrivers = [ "nvidia" ];
    };
}
