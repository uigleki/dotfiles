{
  nixos.modules.systemd-boot.boot.loader = {
    efi.canTouchEfiVariables = true;

    systemd-boot = {
      enable = true;
      configurationLimit = 5; # prevent boot partition running out of space
    };
  };
}
