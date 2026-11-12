{
  # home-manager shares the system pkgs, so its unfree packages are allowed there
  nixos.modules.desktop.nixpkgs.config.allowUnfreePackages = [ "google-chrome" ];

  homeManager.modules.desktop =
    { lib, ... }:
    {
      programs = {
        firefox = {
          enable = true;
          profiles.default = { }; # pin profile name
        };

        google-chrome.enable = true;
      };

      xdg.mimeApps.defaultApplications = lib.genAttrs [
        "text/html"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ] (_: "firefox.desktop");
    };
}
