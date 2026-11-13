{ config, ... }:
let
  inherit (config) owner;
in
{
  nixos.modules.base =
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
          linger = true;
          openssh.authorizedKeys.keys = owner.sshKeys;
        };
      };
    };
}
