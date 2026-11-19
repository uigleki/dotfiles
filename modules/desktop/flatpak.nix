{ inputs, ... }:
{
  nixos.modules.desktop = {
    imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];
    environment.persistence."/cache".directories = [ "/var/lib/flatpak" ];

    services.flatpak = {
      enable = true;
      uninstallUnmanaged = true;

      overrides.global = {
        Context.filesystems = [
          "/nix/store:ro" # home-manager's fontconfig files, icons and cursors are symlinks into it
          "xdg-config/fontconfig:ro"
        ];

        Environment.XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";
      };
    };
  };

  homeManager.modules.desktop = {
    home.persistence."/persist".directories = [ ".local/share/flatpak" ]; # per-user portal permissions
    updateCommands = [ "flatpak update -y" ];
  };
}
