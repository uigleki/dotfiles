{ inputs, ... }:
{
  flake.modules.nixos.desktop = {
    imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

    services.flatpak = {
      enable = true;

      packages = [
        "com.heroicgameslauncher.hgl"
        "com.usebottles.bottles"
      ];

      uninstallUnmanaged = true;
      update.auto.enable = true;
    };
  };
}
