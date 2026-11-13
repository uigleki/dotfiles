{ config, ... }:
let
  inherit (config) user;
in
{
  nixos.modules.base =
    { config, lib, ... }:
    {
      options.user.username = lib.mkOption {
        type = lib.types.singleLineStr;
        default = user.username;
      };

      config = {
        # the first-use lecture record; whole, or impermanence creates the parent 0755
        environment.persistence."/persist".directories = [
          {
            directory = "/var/db/sudo";
            mode = "0711";
          }
        ];

        security.sudo.wheelNeedsPassword = false;

        users.users.${config.user.username} = {
          inherit (user) uid;
          isNormalUser = true;
          extraGroups = [ "wheel" ];
          initialPassword = config.user.username;
          linger = true;
          openssh.authorizedKeys.keys = user.sshKeys;
        };
      };
    };
}
