{ lib, pkgs, ... }:
let
  settings = {
    onboarding = false;
    theme.name = "catppuccin-latte";
    update.version_check = false;

    ui = {
      status_indicators = "symbols";
      toast.delivery = "terminal";
    };
  };
in
{
  home.packages = [ pkgs.unstable.herdr ];

  xdg.configFile."herdr/config.toml" = {
    source = (pkgs.formats.toml { }).generate "herdr-config.toml" settings;
    onChange = "${lib.getExe pkgs.unstable.herdr} server reload-config || true";
  };
}
