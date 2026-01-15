inputs:
let
  inherit (inputs) nixpkgs self;

  eachSystem = nixpkgs.lib.genAttrs [
    "aarch64-linux"
    "x86_64-linux"
  ];
  pkgsFor = system: nixpkgs.legacyPackages.${system};

  lib = import ../lib { inherit inputs; };
  inherit (lib) mkHome mkSystem;

  baseUser = {
    name = "u";
    system = "x86_64-linux";

    gitName = "Ray";
    gitEmail = "30580339+uigleki@users.noreply.github.com";
    flake = "$HOME/.config/dotfiles";

    sshKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDm+4u9INuS/Cm3sqqAaJknGGVIpjA8bVNVdLarmUbjD"
    ];

    # System constants
    # User ID - changing this would break ownership of all existing files
    uid = 1000;
    # Do not change on upgrade
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "25.05";
  };

  akira = baseUser // {
    hostName = "akira";
  };

  inori = baseUser // {
    hostName = "nixos";
    name = "nixos";
  };

  kurisu = baseUser // {
    hostName = "kurisu";
  };

  nazuna = baseUser // {
    hostName = "nazuna";
    system = "aarch64-linux";
  };

  # Future host names: miyabi
in
{
  checks = eachSystem (system: {
    pre-commit-check = inputs.git-hooks.lib.${system}.run {
      hooks = {
        convco.enable = true;
        deadnix.enable = true;
        nil.enable = true;
        nixfmt-rfc-style.enable = true;
        statix.enable = true;
      };
      package = (pkgsFor system).prek;
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

  nixosConfigurations = {
    ${akira.hostName} = mkSystem {
      extraModules = [ ../hosts/akira ];
      user = akira;
    };

    ${inori.hostName} = mkSystem {
      extraModules = [ ../hosts/inori ];
      user = inori;
    };

    ${nazuna.hostName} = mkSystem {
      extraModules = [ ../hosts/nazuna ];
      user = nazuna;
    };
  };

  homeConfigurations = {
    ${kurisu.hostName} = mkHome {
      extraModules = [ ../hosts/kurisu ];
      user = kurisu;
    };
  };
}
