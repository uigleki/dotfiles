{ config, ... }:
let
  inherit (config) owner;
in
{
  flake.modules.nixos.base =
    { config, ... }:
    {
      programs.nh = {
        enable = true;
        flake = "${config.users.users.${config.owner.username}.home}/${owner.flakeDir}";

        clean = {
          enable = true;
          # without --keep-one, direnv projects lose every gcroot
          extraArgs = "--keep-since 30d --keep-one";
        };
      };
    };
}
