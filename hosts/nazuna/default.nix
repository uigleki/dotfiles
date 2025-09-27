{
  imports = [ ./hardware-configuration.nix ];

  boot.binfmt.emulatedSystems = [ "x86_64-linux" ];
  boot.loader.timeout = 0;
}
