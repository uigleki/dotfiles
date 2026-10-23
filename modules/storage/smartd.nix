{
  flake.modules.nixos.desktop.services.smartd = {
    enable = true;
    notifications.systembus-notify.enable = true;
  };
}
