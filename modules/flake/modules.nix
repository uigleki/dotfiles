{ lib, ... }:
let
  # the key lets a module imported along two paths apply once
  option =
    class: name:
    lib.mkOption {
      type = lib.types.deferredModule;
      apply = module: {
        key = "${class}.${name}";
        imports = [ module ];
      };
    };
in
{
  options = {
    nixos.modules = lib.genAttrs [
      "auto-upgrade"
      "base"
      "btrfs"
      "desktop"
      "disko-btrfs"
      "disko-btrfs-luks"
      "lanzaboote"
      "network"
      "security"
      "server"
      "systemd-boot"
      "tpm-unlock"
      "wsl"
    ] (option "nixos");

    homeManager.modules = lib.genAttrs [
      "base"
      "desktop"
    ] (option "homeManager");
  };
}
