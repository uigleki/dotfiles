{ config, ... }:
let
  nixos = config.nixos.modules;
in
{
  nixos.modules.tpm-unlock =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.boot.initrd.luks.devices) root;

      tpm-enroll = pkgs.writeShellApplication {
        name = "tpm-enroll";
        runtimeInputs = [ config.systemd.package ];

        text = ''
          if [[ $(< /sys/class/tpm/tpm0/pcr-sha256/15) =~ ^0+$ ]]; then
            echo "PCR 15 is zero: this boot did not measure the volume key, reboot into this generation first" >&2
            exit 1
          fi

          exec systemd-cryptenroll --wipe-slot=tpm2 --tpm2-device=auto \
            --tpm2-pcrs=0+2+7+12+15:sha256=${lib.strings.replicate 64 "0"} ${root.device}
        '';
      };
    in
    {
      # the bound PCRs identify the boot chain only while Secure Boot restricts what may boot
      imports = [ nixos.lanzaboote ];

      boot.initrd.luks.devices.root.crypttabExtraOpts = [
        "tpm2-device=auto"
        # tpm-enroll binds the slot to a zeroed PCR 15, which this extends on unlock,
        # so a system booted from a substituted volume cannot unseal the key
        "tpm2-measure-pcr=yes"
      ];

      environment.systemPackages = [ tpm-enroll ];
    };
}
