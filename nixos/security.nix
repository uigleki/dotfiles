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
        "slab_nomerge"
        "page_alloc.shuffle=1"
        "pti=on"
        "randomize_kstack_offset=on"
        "vsyscall=none"
        "debugfs=off"
        "oops=panic"
      ];

      kernel.sysctl = {
        "dev.tty.ldisc_autoload" = 0;
        "fs.protected_fifos" = 2;
        "fs.protected_regular" = 2;
        "fs.suid_dumpable" = 0;
        "kernel.kexec_load_disabled" = 1;
        "kernel.kptr_restrict" = 2;
        "kernel.perf_event_paranoid" = 3;
        "kernel.sysrq" = 4;
        "kernel.yama.ptrace_scope" = 2;
        "net.core.default_qdisc" = "cake";
        "net.ipv4.conf.all.rp_filter" = 1;
        "net.ipv4.conf.all.secure_redirects" = 0;
        "net.ipv4.conf.all.send_redirects" = 0;
        "net.ipv4.conf.default.accept_redirects" = 0;
        "net.ipv4.conf.default.secure_redirects" = 0;
        "net.ipv4.conf.default.send_redirects" = 0;
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.ipv4.tcp_fastopen" = 3;
        "net.ipv4.tcp_rfc1337" = 1;
        "net.ipv6.conf.all.accept_redirects" = 0;
        "net.ipv6.conf.default.accept_redirects" = 0;
      };

      blacklistedKernelModules = [
        "dccp"
        "sctp"
        "rds"
        "tipc"
        "ax25"
        "netrom"
        "x25"
        "rose"
        "appletalk"
        "psnap"
        "p8022"
        "atm"

        "cramfs"
        "freevxfs"
        "jffs2"
        "hfs"
        "hfsplus"
        "udf"

        "firewire-core"
        "firewire_core"
        "firewire-ohci"
        "firewire_ohci"
        "firewire_sbp2"
        "firewire-sbp2"
        "firewire-net"
        "ohci1394"
        "sbp2"
      ];
    };
  };
}
