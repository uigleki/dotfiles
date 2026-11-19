{
  # home-manager shares the system pkgs, so its unfree packages are allowed there
  nixos.modules.desktop.nixpkgs.config.allowUnfreePackages = [ "google-chrome" ];

  homeManager.modules.desktop =
    { config, ... }:
    {
      home.persistence = {
        "/persist".directories = [
          ".local/share/pki" # NSS certificates and client keys
          ".pki"
        ];

        # account sync restores them; snapshots would only keep churn
        "/cache".directories = [
          ".config/google-chrome"
          ".config/mozilla"
        ];
      };

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
