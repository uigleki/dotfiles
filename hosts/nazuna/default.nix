{ user, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  boot = {
    binfmt.emulatedSystems = [ "x86_64-linux" ]; # run x86 binaries on ARM
    loader.timeout = 0; # skip bootloader menu
    kernel.sysctl = {
      # allow unprivileged users to bind port 443 for web services
      "net.ipv4.ip_unprivileged_port_start" = 443;
    };
  };

  networking.firewall.allowedTCPPorts = [ 443 ];

  # expose syncthing GUI for remote access
  home-manager.users.${user.name}.services.syncthing.guiAddress = "0.0.0.0:8384";

  myModules = {
    autoUpdate.enable = true;
    server.enable = true;
  };
}
