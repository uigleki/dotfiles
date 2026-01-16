{
  lib,
  pkgs,
  user,
  osConfig ? null,
  ...
}:
let
  isStandalone = osConfig == null; # not running as NixOS module
in
{
  imports = [
    ./core.nix
    ./desktop.nix
    ./dev.nix
    ./network.nix
    ./theme.nix
  ]
  ++ lib.optionals isStandalone [ ../shared/nix.nix ];

  config = lib.mkIf isStandalone {
    home = {
      username = user.name;
      homeDirectory = "/home/${user.name}";
    };

    nix = {
      package = pkgs.nix;
      gc.dates = "03:15";
    };

    programs.home-manager.enable = true;
    news.display = "silent";
  };
}
