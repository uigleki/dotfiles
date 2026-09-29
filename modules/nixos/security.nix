# Hardening options based on kernel-hardening-checker recommendations.
# Excludes settings that impact normal usage or performance.

{ config, lib, ... }:
let
  cfg = config.myModules.security;
in
{
  options.myModules.security.enable = lib.mkEnableOption "security hardening" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    boot = {
      kernelParams = [ "bdev_allow_write_mounted=0" ];

      blacklistedKernelModules = [
        "appletalk"
        "atm"
        "ax25"
        "cramfs"
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

      kernel.sysctl = {
        "dev.tty.ldisc_autoload" = 0;

        "fs.protected_fifos" = 2;
        "fs.protected_regular" = 2;
        "fs.suid_dumpable" = 0;

        "kernel.kptr_restrict" = 2;
        "kernel.oops_limit" = 100;
        "kernel.warn_limit" = 100;

        "net.ipv4.conf.all.send_redirects" = 0;
        "net.ipv4.conf.default.accept_redirects" = 0;
        "net.ipv4.conf.default.send_redirects" = 0;
        "net.ipv6.conf.all.accept_redirects" = 0;
        "net.ipv6.conf.default.accept_redirects" = 0;
      };
    };

    security.protectKernelImage = true;

    # disabling systemd-coredump would make crashing services write core files into their cwd
    systemd.coredump.settings.Coredump = {
      ProcessSizeMax = 0;
      Storage = "none";
    };
  };
}
