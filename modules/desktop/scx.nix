{
  flake.modules.nixos.desktop.services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };
}
