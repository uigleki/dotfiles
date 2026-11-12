{
  nixos.modules.desktop.services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };
}
