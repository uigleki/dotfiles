{ inputs }:
{
  extraModules ? [ ],
  user,
}:
inputs.nixpkgs.lib.nixosSystem {
  inherit (user) system;
  modules = [
    ../modules/nixos
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${user.name}.imports = [ ../modules/home ];
        extraSpecialArgs = { inherit inputs user; };
      };
    }
  ]
  ++ extraModules;
  specialArgs = { inherit inputs user; };
}
