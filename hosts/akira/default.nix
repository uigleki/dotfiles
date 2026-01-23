{ user, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  myModules = {
    desktop.enable = true;
    secureBoot.enable = true;
  };

  boot = {
    loader.timeout = 1;

    kernelParams = [
      "amdgpu.dcdebugmask=0x410" # disable PSR & Panel Replay to fix visual stuttering
      "amdgpu.sg_display=0" # disable Scatter/Gather to fix white screen flashing
    ];
  };

  hardware.nvidia = {
    open = true;

    powerManagement = {
      enable = true;
      finegrained = true;
    };

    prime = {
      amdgpuBusId = "PCI:5:0:0";
      nvidiaBusId = "PCI:1:0:0";

      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];

  home-manager.users.${user.name}.programs.plasma.configFile = {
    kcminputrc."Libinput/1267/12474/ELAN1200:00 04F3:30BA Touchpad".DisableEventsOnExternalMouse = true;
  };
}
