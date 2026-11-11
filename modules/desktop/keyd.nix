{
  flake.modules.nixos.desktop.services.keyd = {
    enable = true;
    keyboards.default.settings.main.capslock = "home";
  };
}
