{
  flake.modules.nixos.desktop.services.keyd = {
    enable = true;

    keyboards.default = {
      ids = [ "*" ];
      settings.main.capslock = "home";
    };
  };
}
