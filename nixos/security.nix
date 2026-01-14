{ config, lib, ... }:
let
  cfg = config.myModules.security;
in
# Hardening options based on kernel-hardening-checker recommendations.
# Excludes settings that impact normal usage or performance.
{
  options.myModules.security.enable = lib.mkEnableOption "security hardening" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    boot = {
      blacklistedKernelModules = [
        "appletalk"
        "atm"
        "ax25"
        "cramfs"
        "dccp"
        "firewire-core"
        "freevxfs"
        "hfs"
        "hfsplus"
        "jffs2"
        "netrom"
        "p8022"
        "psnap"
        "rds"
        "rose"
        "sctp"
        "tipc"
        "udf"
        "x25"
      ];

      kernelParams = [
        "bdev_allow_write_mounted=0"
        "debugfs=off"
      ];

      kernel.sysctl = {
        "dev.tty.ldisc_autoload" = 0;
        "dev.tty.legacy_tiocsti" = 0;

        "fs.protected_fifos" = 2;
        "fs.protected_hardlinks" = 1;
        "fs.protected_regular" = 2;
        "fs.protected_symlinks" = 1;
        "fs.suid_dumpable" = 0;

        "kernel.dmesg_restrict" = 1;
        "kernel.kexec_load_disabled" = 1;
        "kernel.kptr_restrict" = 2;
        "kernel.oops_limit" = 100;
        "kernel.randomize_va_space" = 2;
        "kernel.warn_limit" = 100;

        "net.ipv4.conf.all.rp_filter" = 1;
        "net.ipv4.conf.all.send_redirects" = 0;
        "net.ipv4.conf.default.accept_redirects" = 0;
        "net.ipv4.conf.default.accept_source_route" = 0;
        "net.ipv4.conf.default.rp_filter" = 1;
        "net.ipv4.conf.default.send_redirects" = 0;
        "net.ipv6.conf.all.accept_redirects" = 0;
        "net.ipv6.conf.default.accept_redirects" = 0;

        "vm.unprivileged_userfaultfd" = 0;
      };
    };

    security.protectKernelImage = true;

    systemd.coredump.enable = false;
  };
}
