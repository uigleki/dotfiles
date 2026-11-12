{
  nixos.modules.desktop.programs.kdeconnect.enable = true;

  homeManager.modules.desktop.services.kdeconnect = {
    enable = true;
    indicator = true;
  };
}
