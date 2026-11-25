{ config, ... }:
let
  nixos = config.nixos.modules;
in
{
  nixos.modules.desktop =
    { pkgs, ... }:
    {
      imports = with nixos; [
        base
        hardening
        network
      ];

      environment.systemPackages = with pkgs; [
        libnotify
        wl-clipboard
      ];
    };

  homeManager.modules.desktop = {
    home.persistence = {
      "/cache".directories = [
        "Downloads"

        # launchers and icons that installers such as Steam and Wine write
        ".local/share/applications"
        ".local/share/icons"
        ".local/share/mime"
        ".local/share/vulkan"
      ];

      "/persist".directories = [
        ".config/dconf" # settings of GTK apps
        "Desktop"
        "Documents"
        "Music"
        "Pictures"
        "Public"
        "Templates"
        "Videos"
      ];
    };

    xdg = {
      # each app's file names the types it opens
      mimeApps.enable = true;
      # keeps the default English names under any login locale
      userDirs.enable = true;
    };
  };
}
