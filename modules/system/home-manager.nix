{ config, inputs, ... }:
let
  inherit (config) owner;
  inherit (config.flake.modules) homeManager;
in
{
  flake.modules = {
    nixos.base =
      { config, ... }:
      {
        imports = [ inputs.home-manager.nixosModules.home-manager ];

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${config.owner.username}.imports = [ homeManager.base ];
        };
      };

    homeManager.base.home.stateVersion = owner.stateVersion;
  };
}
