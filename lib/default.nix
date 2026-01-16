{ inputs }:
let
  inherit (inputs) nixpkgs home-manager;
in
{
  mkSystem =
    {
      user,
      extraModules ? [ ],
    }:
    nixpkgs.lib.nixosSystem {
      inherit (user) system;
      specialArgs = { inherit inputs user; };
      modules = [
        ../modules/nixos
        home-manager.nixosModules.home-manager
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
    };

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
}
