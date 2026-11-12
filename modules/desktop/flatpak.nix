{ inputs, ... }:
{
  nixos.modules.desktop = {
    imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

    services.flatpak = {
      enable = true;

      packages = [
        "com.heroicgameslauncher.hgl"
        "com.usebottles.bottles"
      ];

      uninstallUnmanaged = true;
    };
  };

  homeManager.modules.desktop.updateCommands = [ "flatpak update -y" ];
}
