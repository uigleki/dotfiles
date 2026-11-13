{ config, inputs, ... }:
let
  inherit (config) user;
  homeManager = config.homeManager.modules;
in
{
  nixos.modules.base =
    { config, ... }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${config.user.username}.imports = [ homeManager.base ];
      };
    };

  homeManager.modules.base.home.stateVersion = user.stateVersion;
}
