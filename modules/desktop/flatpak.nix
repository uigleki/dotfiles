{ inputs, ... }:
{
  nixos.modules.desktop = {
    imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];
    environment.persistence."/cache".directories = [ "/var/lib/flatpak" ];

    services.flatpak = {
      enable = true;

      overrides.settings.global = {
        Context.filesystems = [
          "/nix/store:ro" # home-manager's fontconfig files, icons and cursors are symlinks into it
          "xdg-config/fontconfig:ro"
        ];

        Environment.XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";
      };

      uninstallUnmanaged = true;
    };
  };

  homeManager.modules.desktop =
    { config, ... }:
    let
      inherit (config.gtk) iconTheme;
    in
    {
      home.persistence."/persist".directories = [ ".local/share/flatpak" ]; # per-user portal permissions
      updateCommands = [ "flatpak update -y" ];
      # Flatpak apps see the user's icons but not the home-manager profile
      xdg.dataFile."icons/${iconTheme.name}".source =
        "${iconTheme.package}/share/icons/${iconTheme.name}";
    };
}
