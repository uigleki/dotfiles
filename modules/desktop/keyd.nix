{
  flake.modules.nixos.desktop = {
    # libinput takes keyd's virtual keyboard for an external one and stops disabling the touchpad while typing
    environment.etc."libinput/local-overrides.quirks".text = ''
      [Serial Keyboards]
      MatchUdevType=keyboard
      MatchName=keyd*keyboard
      AttrKeyboardIntegration=internal
    '';

    services.keyd = {
      enable = true;
      keyboards.default.settings.main.capslock = "home";
    };
  };
}
