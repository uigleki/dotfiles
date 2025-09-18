{
  config,
  lib,
  user,
  ...
}:
let
  cfg = config.myModules.isNixOS;
in
{
  options.myModules.isNixOS = lib.mkEnableOption "NixOS system" // {
    default = true;
  };

  imports = [
    ./core.nix
    ./dev.nix
    ./gui.nix
  ]
  ++ lib.optionals (!cfg) [ ./nix.nix ];

  config = lib.mkIf (!cfg) {
    home = {
      username = user.name;
      homeDirectory = "/home/${user.name}";
    };
  };
}
