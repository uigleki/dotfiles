{
  nixos.modules.desktop = {
    environment.persistence."/persist".directories = [ "/var/lib/fwupd" ];
    services.fwupd.enable = true;
  };
}
