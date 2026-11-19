{
  # home-manager shares the system pkgs, so its unfree packages are allowed there
  nixos.modules.desktop.nixpkgs.config.allowUnfreePackages = [ "google-chrome" ];

  homeManager.modules.desktop =
    { config, ... }:
    {
      home.persistence."/persist".directories = [
        ".config/google-chrome"
        ".config/mozilla"
        ".local/share/pki" # NSS certificates and client keys
        ".pki"
      ];

      programs = {
        firefox = {
          enable = true;

          policies = {
            DisableTelemetry = true;
            FirefoxHome.SponsoredTopSites = false;
          };

          profiles.default = { }; # pin profile name
        };

        google-chrome.enable = true;
      };

      xdg.mimeApps.defaultApplicationPackages = [ config.programs.firefox.finalPackage ];
    };
}
