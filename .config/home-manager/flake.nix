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
      pkgs = nixpkgs.legacyPackages.${system};

      optionalTOML = path:
        nixpkgs.lib.optionalAttrs (builtins.pathExists path)
        (builtins.fromTOML (builtins.readFile path));

      userConfig = { inherit username; } // optionalTOML ./config.toml;
    in {
      homeConfigurations.${username} =
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
          extraSpecialArgs = { inherit userConfig; };
        };
    };
}
