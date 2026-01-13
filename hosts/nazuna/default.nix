{ user, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  myModules = {
    autoUpdate.enable = true;
    server.enable = true;
  };

  boot = {
    binfmt.emulatedSystems = [ "x86_64-linux" ]; # run x86 binaries on ARM
    kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 443; # allow binding port 443
    loader.timeout = 0; # skip bootloader menu
  };

  networking.firewall.allowedTCPPorts = [ 443 ];

  # expose syncthing GUI for remote access
  home-manager.users.${user.name}.services.syncthing.guiAddress = "0.0.0.0:8384";
}
