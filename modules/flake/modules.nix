{ lib, ... }:
let
  # the key lets a module imported along two paths apply once
  option =
    name:
    lib.mkOption {
      type = lib.types.deferredModule;
      apply = module: {
        key = name;
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
      "hardening"
      "network"
      "secure-boot"
      "server"
      "systemd-boot"
      "tpm-unlock"
      "wsl"
    ] option;

    homeManager.modules = lib.genAttrs [
      "base"
      "desktop"
    ] option;
  };
}
