{ config, ... }:
let
  inherit (config) user;
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

        flake = "${config.users.users.${config.user.username}.home}/${user.flakeDir}";
      };
    };

  # build times nix-output-monitor estimates from
  homeManager.modules.base.home.persistence."/cache".directories = [
    ".local/state/nix-output-monitor"
  ];
}
