{
  config,
  inputs,
  lib,
  ...
}:
{
  # host names: nazuna, akira, inori, kurisu, miyabi, hitagi, yuna
  options.nixos.configurations = lib.mkOption {
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
        { networking.hostName = name; }
      ];
    }
  ) config.nixos.configurations;
}
