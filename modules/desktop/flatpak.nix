{ inputs, ... }:
{
  nixos.modules.desktop = {
    imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];
    environment.persistence."/cache".directories = [ "/var/lib/flatpak" ];

    services.flatpak = {
      enable = true;
      uninstallUnmanaged = true;
    };
  };

  homeManager.modules.desktop.updateCommands = [ "flatpak update -y" ];
}
