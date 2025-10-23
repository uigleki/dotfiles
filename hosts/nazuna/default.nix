{ user, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  boot = {
    binfmt.emulatedSystems = [ "x86_64-linux" ];
    loader.timeout = 0;
    kernel.sysctl = {
      "net.ipv4.ip_unprivileged_port_start" = 443;
    };
  };

  networking.firewall.allowedTCPPorts = [ 443 ];

  home-manager.users.${user.name}.services.syncthing.guiAddress = "0.0.0.0:8384";

  myModules.autoUpdate.enable = true;
}
