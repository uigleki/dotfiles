{
  osConfig ? null,
  lib,
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
  ]
  ++ lib.optionals notNixOS [ ./nix.nix ];

  config = lib.mkIf notNixOS {
    home = {
      username = user.name;
      homeDirectory = "/home/${user.name}";
    };
  };
}
