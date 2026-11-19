{
  nixos.modules.desktop = {
    nixpkgs.config.allowUnfreePackages = [ "google-chrome" ];

    programs.chromium = {
      enable = true;
      extraOpts.MetricsReportingEnabled = false;
    };
  };

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

          profiles.default.search = {
            default = "ddg";
            force = true;
          };
        };

        google-chrome.enable = true;
      };

      xdg.mimeApps.defaultApplicationPackages = [ config.programs.firefox.finalPackage ];
    };
}
