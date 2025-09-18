{
  lib,
  user,
  isNixOS,
  ...
}:
{
  imports = [
    ./core.nix
    ./dev.nix
    ./gui.nix
  ]
  ++ lib.optionals (!isNixOS) [ ./nix.nix ];

  home = {
    username = user.name;
    homeDirectory = "/home/${user.name}";
  };
}
