{ config, inputs, ... }:
let
  inherit (config) owner;
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
        users.${config.owner.username}.imports = [ homeManager.base ];
      };
    };

  homeManager.modules.base.home.stateVersion = owner.stateVersion;
}
