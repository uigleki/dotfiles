{ user, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  myModules = {
    gui.enable = true;
    secureBoot.enable = true;
  };

  boot.loader.timeout = 1;

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

  home-manager.users.${user.name} = {
    programs.plasma.configFile = {
      kcminputrc."Libinput/1267/12474/ELAN1200:00 04F3:30BA Touchpad".DisableEventsOnExternalMouse = true;
    };
  };
}
