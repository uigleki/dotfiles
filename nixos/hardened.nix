{
  boot = {
    kernelParams = [
      "randomize_kstack_offset=on"
    ];
    blacklistedKernelModules = [
      "ax25"
      "dccp"
      "decnet"
      "econet"
      "netrom"
      "rds"
      "rose"
      "tipc"
    ];
    kernel.sysctl = {
      "fs.protected_hardlinks" = 1;
      "fs.protected_symlinks" = 1;
      "fs.suid_dumpable" = 0;
      "kernel.dmesg_restrict" = 1;
      "kernel.kptr_restrict" = 2;
      "net.ipv4.conf.all.rp_filter" = 1;
      "net.ipv4.conf.default.rp_filter" = 1;
      "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
      "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
      "net.ipv4.tcp_rfc1337" = 1;
      "net.ipv4.tcp_syncookies" = 1;
      "vm.mmap_rnd_bits" = 32;
      "vm.mmap_rnd_compat_bits" = 16;
      "vm.unprivileged_userfaultfd" = 0;
    };
  };
}
