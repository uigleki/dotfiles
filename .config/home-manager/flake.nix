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
      system = builtins.currentSystem;
      username = builtins.getEnv "USER";
      pkgs = nixpkgs.legacyPackages.${system};
      userConfig = (builtins.fromTOML
        (builtins.readFile /home/${username}/.config/home-manager/config.toml))
        // {
          inherit username;
        };
    in {
      homeConfigurations.${username} =
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
          extraSpecialArgs = { inherit userConfig; };
        };
    };
}
