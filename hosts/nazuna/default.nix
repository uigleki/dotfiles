{ user, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  myModules = {
    autoUpdate.enable = true;
    server.enable = true;
  };

  boot = {
    binfmt.emulatedSystems = [ "x86_64-linux" ]; # run x86 binaries on ARM
    loader.timeout = 0; # skip bootloader menu
  };

  # expose syncthing GUI for remote access
  home-manager.users.${user.name}.services.syncthing.guiAddress = "0.0.0.0:8384";
}
