{
  osConfig ? null,
  lib,
  pkgs,
  user,
  ...
}:
let
  notNixOS = osConfig == null;
in
{
  imports = [
    ./core.nix
    ./dev.nix
    ./gui.nix
    ./network.nix
    ./theme.nix
  ]
  ++ lib.optionals notNixOS [ ./nix.nix ];

  config = lib.mkIf notNixOS {
    home = {
      username = user.name;
      homeDirectory = "/home/${user.name}";
    };
    nix.package = pkgs.nix;
  };
}
