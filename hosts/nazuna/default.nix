{
  imports = [ ./hardware-configuration.nix ];

  boot.binfmt.emulatedSystems = [ "x86_64-linux" ];
  myModules.boot.timeout = 0;
}
