{
  flake.modules.nixos.desktop = {
    # real-time scheduling for PipeWire
    security.rtkit.enable = true;

    # Plasma enables PipeWire itself
    services.pipewire.jack.enable = true;
  };
}
