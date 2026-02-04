inputs:
let
  inherit (inputs) nixpkgs self;
  inherit (nixpkgs) lib;
  inherit (import ../lib { inherit inputs; }) mkHome mkSystem;

  eachSystem = lib.genAttrs [
    "aarch64-linux"
    "x86_64-linux"
  ];
  pkgsFor = system: nixpkgs.legacyPackages.${system};

  baseUser = {
    name = "u";
    system = "x86_64-linux";

    gitName = "Ray";
    gitEmail = "30580339+uigleki@users.noreply.github.com";
    flake = "$HOME/.config/dotfiles";
    syncDir = "$HOME/sync/a";

    sshKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDm+4u9INuS/Cm3sqqAaJknGGVIpjA8bVNVdLarmUbjD"
    ];

    # user ID - changing this would break ownership of all existing files
    uid = 1000;
    # do not change on upgrade
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "25.05";
  };

  homeHosts = {
    kurisu = { };
  };

  nixosHosts = {
    nazuna = {
      system = "aarch64-linux";
    };

    akira = { };

    inori = {
      name = "nixos"; # keep WSL default to avoid home directory migration
    };

    # future host names: miyabi, hitagi
  };
in
{
  checks = eachSystem (system: {
    pre-commit-check = inputs.git-hooks.lib.${system}.run {
      hooks = lib.genAttrs [ "convco" "deadnix" "nil" "nixfmt-rfc-style" "statix" ] (_: {
        enable = true;
      });
      package = (pkgsFor system).prek; # rust pre-commit alternative
      src = ../.;
    };
  });

  devShells = eachSystem (system: {
    default =
      let
        check = self.checks.${system}.pre-commit-check;
      in
      (pkgsFor system).mkShellNoCC {
        inherit (check) shellHook;
        packages = check.enabledPackages;
      };
  });

  formatter = eachSystem (system: (pkgsFor system).nixfmt-rfc-style);

  homeConfigurations = lib.mapAttrs (
    hostName: extra:
    mkHome {
      user = baseUser // { inherit hostName; } // extra;
    }
  ) homeHosts;

  nixosConfigurations = lib.mapAttrs (
    hostName: extra:
    mkSystem {
      user = baseUser // { inherit hostName; } // extra;
      extraModules = [ ../hosts/${hostName} ];
    }
  ) nixosHosts;
}
