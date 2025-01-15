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
      system = "SYSTEM_PLACEHOLDER";
      pkgs = nixpkgs.legacyPackages.${system};
      specialArgs = { inherit pkgs userConfig; };
    in {
      homeConfigurations."USERNAME_PLACEHOLDER" =
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
          extraSpecialArgs = specialArgs;
        };
    };
}
