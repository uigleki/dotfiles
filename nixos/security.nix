{ config, lib, ... }:
let
  cfg = config.myModules.security;
in
{
  options.myModules.security.enable = lib.mkEnableOption "Enable security hardening." // {
    default = true;
  };

  config = lib.mkIf cfg.enable {

    security = {
      protectKernelImage = true;
      forcePageTableIsolation = true;
    };

    systemd.coredump.enable = false;

    boot = {
      kernelParams = [
        "bdev_allow_write_mounted=0"
        "debugfs=off"
        "page_alloc.shuffle=1"
        "slab_nomerge"
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
        "kernel.perf_event_paranoid" = 3;
        "kernel.randomize_va_space" = 2;
        "kernel.warn_limit" = 100;
        "kernel.yama.ptrace_scope" = 3;
        "net.core.default_qdisc" = "cake";
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.ipv4.tcp_fastopen" = 3;
        "vm.unprivileged_userfaultfd" = 0;
      };

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
    };
  };
}
