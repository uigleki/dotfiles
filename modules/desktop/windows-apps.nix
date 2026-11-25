let
  bottles = "com.usebottles.bottles";
in
{
  nixos.modules.desktop.services.flatpak.packages = [ bottles ];

  homeManager.modules.desktop = {
    home.persistence."/cache".directories = [ ".var/app/${bottles}" ];

    services.ludusavi.settings.roots = [
      {
        path = "~/.var/app/${bottles}/data/bottles/bottles/*";
        store = "otherWine";
      }
    ];
  };
}
