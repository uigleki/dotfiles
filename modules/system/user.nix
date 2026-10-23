{ config, ... }:
let
  inherit (config) owner;
in
{
  flake.modules.nixos.base =
    { config, lib, ... }:
    {
      options.owner.username = lib.mkOption {
        type = lib.types.singleLineStr;
        default = owner.username;
      };

      config = {
        security.sudo.wheelNeedsPassword = false;

        users.users.${config.owner.username} = {
          inherit (owner) uid;
          isNormalUser = true;
          extraGroups = [ "wheel" ];
          initialPassword = config.owner.username;
          linger = true; # allow user services to run without login session
          openssh.authorizedKeys.keys = owner.sshKeys;
        };
      };
    };
}
