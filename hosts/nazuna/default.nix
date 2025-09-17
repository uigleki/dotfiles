{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ../../nixos/disk-config.nix
    ../../nixos/network.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };

    binfmt.emulatedSystems = [ "x86_64-linux" ];
  };
}
