{ inputs, ... }:
{
  flake.modules = {
    nixos.desktop = {
      imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

      # keeps the cached Xwayland: the path is compiled in, and flatpak's fonts.fontDir would set one
      programs.xwayland.defaultFontPath = "";

      services.flatpak = {
        enable = true;

        packages = [
          "com.heroicgameslauncher.hgl"
          "com.usebottles.bottles"
        ];

        uninstallUnmanaged = true;
      };
    };

    homeManager.desktop.updateCommands = [ "flatpak update -y" ];
  };
}
