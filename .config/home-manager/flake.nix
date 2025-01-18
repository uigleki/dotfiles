{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      inherit (import ./.local) system username;
      userConfig = (builtins.fromTOML (builtins.readFile ./config.toml)) // {
        inherit username;
      };
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations.${username} =
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
          extraSpecialArgs = { inherit userConfig; };
        };
    };
}
