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
      userConfigContent = builtins.readFile ~/.config/home-manager/config.toml;
      userConfig = builtins.fromTOML userConfigContent;
      system = builtins.currentSystem;
      username = builtins.getEnv "USER";
      pkgs = nixpkgs.legacyPackages.${system};
      specialArgs = { inherit userConfig; };
    in {
      homeConfigurations."${username}" =
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
          extraSpecialArgs = specialArgs;
        };
    };
}
