{
  nixos.modules.desktop = {
    # real-time scheduling for PipeWire
    security.rtkit.enable = true;

    # the graphical-desktop module enables PipeWire itself
    services.pipewire.jack.enable = true;
  };

  homeManager.modules.desktop.home.persistence."/persist".directories = [
    ".local/state/wireplumber" # volumes and default devices
  ];
}
