{
  config,
  inputs,
  lib,
  ...
}:
{
  # future host names: kurisu, miyabi, hitagi, yuna
  options.configurations.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options.module = lib.mkOption { type = lib.types.deferredModule; };
      }
    );
    default = { };
  };

  config.flake.nixosConfigurations = lib.mapAttrs (
    name:
    { module }:
    inputs.nixpkgs.lib.nixosSystem {
      modules = [
        module
        { networking.hostName = lib.mkDefault name; }
      ];
    }
  ) config.configurations.nixos;
}
