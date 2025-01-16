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
      userConfig = builtins.fromTOML (builtins.readFile ./config.toml);
      pkgs = nixpkgs.legacyPackages.${userConfig.const.system};
    in {
      homeConfigurations.${userConfig.const.username} =
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
          extraSpecialArgs = { inherit userConfig; };
        };
    };
}
