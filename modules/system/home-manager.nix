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

  homeManager.modules.base.home = {
    inherit (user) stateVersion;
    persistence."/cache".directories = [ ".local/state/home-manager" ]; # the previous generation, so boot restarts only changed units
  };
}
