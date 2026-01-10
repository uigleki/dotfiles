{
  imports = [
    ../../nixos/secure-boot.nix
    ./hardware-configuration.nix
  ];

  myModules.gui.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    powerManagement.enable = true;
    open = true;
    prime = {
      sync.enable = true;
      amdgpuBusId = "PCI:5:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
