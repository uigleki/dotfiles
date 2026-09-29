{ inputs }:
let
  inherit (inputs) nixpkgs home-manager;
in
{
  mkHome =
    {
      user,
      extraModules ? [ ],
    }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${user.system};
      extraSpecialArgs = { inherit inputs user; };
      modules = [ ../modules/home ] ++ extraModules;
    };

  mkSystem =
    {
      user,
      extraModules ? [ ],
    }:
    nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs user; };

      modules = [
        ../modules/nixos
        home-manager.nixosModules.home-manager
        {
          nixpkgs.hostPlatform = user.system;

          home-manager = {
            extraSpecialArgs = { inherit inputs user; };
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${user.name}.imports = [ ../modules/home ];
          };
        }
      ]
      ++ extraModules;
    };
}
