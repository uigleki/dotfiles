{ config, lib, ... }:
let
  cfg = config.myModules.security;
in
{
  options.myModules.security.enable = lib.mkEnableOption "Enable security configuration." // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    systemd.coredump.enable = false;
    services.dbus.implementation = "broker";

    boot = {
      kernelParams = [
        "init_on_alloc=1"
        "init_on_free=1"
        "page_alloc.shuffle=1"
        "randomize_kstack_offset=on"
        "vsyscall=none"
      ];

      kernelModules = [ "tcp_bbr" ];

      kernel.sysctl = {
        "fs.protected_fifos" = 2;
        "fs.protected_regular" = 2;
        "kernel.kexec_load_disabled" = 1;
        "kernel.kptr_restrict" = 2;
        "net.core.default_qdisc" = "cake";
        "net.ipv4.conf.all.accept_redirects" = 0;
        "net.ipv4.conf.all.rp_filter" = 1;
        "net.ipv4.conf.all.send_redirects" = 0;
        "net.ipv4.conf.default.accept_redirects" = 0;
        "net.ipv4.conf.default.send_redirects" = 0;
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.ipv4.tcp_fastopen" = 3;
        "net.ipv4.tcp_rfc1337" = 1;
        "net.ipv6.conf.all.accept_redirects" = 0;
        "net.ipv6.conf.default.accept_redirects" = 0;
      };
    };
  };
}
