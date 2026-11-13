{ inputs, ... }:
{
  nixos.modules = {
    # feature modules declare state under environment.persistence; it binds only on hosts importing impermanence
    base =
      { lib, ... }:
      {
        imports = [ inputs.impermanence.nixosModules.impermanence ];
        environment.persistence."/persist".enable = lib.mkDefault false;
      };

    impermanence =
      {
        config,
        lib,
        utils,
        ...
      }:
      let
        inherit (config.fileSystems."/") device;
        deviceUnit = "${utils.escapeSystemdPath device}.device";
      in
      {
        # script verbatim from the impermanence README; find -mtime ages an old root by its last change, so one untouched for 30 days is deleted the boot it retires
        boot.initrd.systemd.services.wipe-root = {
          after = [
            deviceUnit
            "local-fs-pre.target" # let hibernation resume before touching data
          ];

          before = [ "sysroot.mount" ];
          requires = [ deviceUnit ];

          script = ''
            mkdir /btrfs_tmp
            mount ${device} /btrfs_tmp
            trap 'umount /btrfs_tmp' EXIT
            if [[ -e /btrfs_tmp/root ]]; then
                mkdir -p /btrfs_tmp/old_roots
                timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
                mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
            fi
            for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
                btrfs subvolume delete --recursive "$i"
            done
            btrfs subvolume create /btrfs_tmp/root
          '';

          serviceConfig.Type = "oneshot";
          unitConfig.DefaultDependencies = false;
          wantedBy = [ "initrd.target" ];
        };

        environment.persistence."/persist" = {
          enable = true;

          directories = [
            # caches, to skip refetching (root's flake inputs, fwupd metadata)
            "/root/.cache/nix"
            "/var/cache"

            "/var/lib/lastlog"
            "/var/lib/logrotate"
            "/var/lib/machines"
            "/var/lib/nixos" # unused under userborn; persisted so impermanence's uid/gid warning stays quiet
            "/var/lib/portables"
            "/var/lib/systemd" # whole: credential.secret is created on first use and opened with O_NOFOLLOW, so a per-file symlink never holds it
            "/var/lib/userborn"
            "/var/log"

            {
              directory = "/var/tmp";
              mode = "1777";
            }
          ]
          ++ lib.optional config.networking.dhcpcd.enable "/var/lib/dhcpcd"; # DUID, or each boot is a new DHCP client

          files = [
            "/etc/machine-id"

            # userborn on 26.05 never writes these (rootless podman fails on fresh installs); drop on 26.11 (NixOS/nixpkgs#508608)
            "/etc/subgid"
            "/etc/subuid"
          ];

          hideMounts = true;
        };

        fileSystems."/persist".neededForBoot = true;

        # logrotate replaces its state file by rename, which a bind-mounted file cannot take (nix-community/impermanence#270)
        services.logrotate.extraArgs = lib.mkAfter [
          "--state"
          "/var/lib/logrotate/logrotate.status"
        ];

        # passwd renames a new /etc/shadow into place, which fails on a bind-mounted file; userborn's symlink is resolved first
        services.userborn = {
          enable = true;
          passwordFilesLocation = "/persist/etc";
        };

        # only the perl user script creates /root; otherwise impermanence makes it as a 0755 parent
        users.users.root.createHome = true;
      };
  };
}
