{ user, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  myModules = {
    desktop.enable = true;
    secureBoot.enable = true;
  };

  boot.loader.timeout = 1;

  hardware.nvidia = {
    open = true; # only set to false if older than RTX 20 series
    powerManagement.enable = true; # preserve VRAM on suspend
    prime = {
      amdgpuBusId = "PCI:5:0:0";
      nvidiaBusId = "PCI:1:0:0";

      offload = {
        enable = true; # most games auto-use dGPU
        enableOffloadCmd = true;
      };
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024; # 8GB
    }
  ];

  home-manager.users.${user.name}.programs.plasma.configFile = {
    kcminputrc."Libinput/1267/12474/ELAN1200:00 04F3:30BA Touchpad".DisableEventsOnExternalMouse = true;
  };
}
