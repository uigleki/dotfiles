{
  nixos.modules.desktop.services.flatpak.packages = [ "com.usebottles.bottles" ];

  homeManager.modules.desktop.home.persistence."/cache".directories = [
    ".var/app/com.usebottles.bottles"
  ];
}
