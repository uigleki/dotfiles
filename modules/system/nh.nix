{ config, ... }:
let
  inherit (config) owner;
in
{
  nixos.modules.base =
    { config, ... }:
    {
      programs.nh = {
        enable = true;

        clean = {
          enable = true;

          # without --keep-one, direnv projects lose every gcroot
          extraArgs = "--keep-since 30d --keep-one";
        };

        flake = "${config.users.users.${config.owner.username}.home}/${owner.flakeDir}";
      };
    };
}
