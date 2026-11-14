{
  nixos.modules.desktop =
    { config, ... }:
    {
      environment.persistence."/cache".users.${config.user.username}.directories = [
        ".var/app/com.usebottles.bottles"
      ];

      services.flatpak.packages = [ "com.usebottles.bottles" ];
    };
}
