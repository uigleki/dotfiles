{
  osConfig ? null,
  lib,
  pkgs,
  user,
  ...
}:
let
  isStandalone = osConfig == null;
in
{
  imports = [
    ./core.nix
    ./dev.nix
    ./gui.nix
    ./network.nix
    ./theme.nix
  ]
  ++ lib.optionals isStandalone [
    ../nixos/nix.nix
    ../nixos/overlay.nix
  ];

  config = lib.mkIf isStandalone {
    home = {
      username = user.name;
      homeDirectory = "/home/${user.name}";
    };

    nix = {
      package = pkgs.nix;
      gc.frequency = "03:15";
    };

    news.display = "silent";
  };
}
