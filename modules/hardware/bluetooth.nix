{
  nixos.modules.desktop = {
    environment.persistence."/persist".directories = [ "/var/lib/bluetooth" ];
    hardware.bluetooth.enable = true;
  };
}
