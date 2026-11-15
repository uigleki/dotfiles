{
  nixos.modules.desktop.programs.kdeconnect.enable = true;

  homeManager.modules.desktop = {
    home.persistence."/persist".directories = [ ".config/kdeconnect" ]; # pairings

    services.kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
}
