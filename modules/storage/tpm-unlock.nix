{ config, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  flake.modules.nixos.tpm-unlock = {
    # the bound PCRs identify the boot chain only while Secure Boot restricts what may boot
    imports = [ nixos.lanzaboote ];

    disko.devices.disk.main.content.partitions.luks.content.settings.crypttabExtraOpts = [
      "tpm2-device=auto"
    ];
  };
}
