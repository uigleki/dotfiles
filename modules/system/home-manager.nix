{ config, inputs, ... }:
let
  inherit (config) user;
in
{
  nixos.modules.base = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };

  homeManager.modules.base.home = {
    inherit (user) stateVersion;
    persistence."/cache".directories = [ ".local/state/home-manager" ]; # the previous generation, so boot restarts only changed units
  };
}
