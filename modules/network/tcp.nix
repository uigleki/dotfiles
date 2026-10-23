let
  bufferSize = 16 * 1024 * 1024; # 16 MiB in bytes
in
{
  flake.modules.nixos.network.boot.kernel.sysctl = {
    # high-throughput, low-latency networking
    "net.core.default_qdisc" = "cake";
    "net.core.rmem_max" = bufferSize;
    "net.core.wmem_max" = bufferSize;
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.tcp_fastopen" = 3;
  };
}
