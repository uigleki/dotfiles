{
  flake.modules.nixos.desktop = {
    # real-time scheduling for PipeWire
    security.rtkit.enable = true;

    # Plasma enables PipeWire itself
    services.pipewire = {
      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;
    };
  };
}
