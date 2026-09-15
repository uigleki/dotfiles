{ lib, pkgs, ... }:
let
  settings = {
    onboarding = false;
    theme.name = "catppuccin-latte";
    ui.toast.delivery = "terminal";
    update.version_check = false;
  };
in
{
  home.packages = [ pkgs.unstable.herdr ];

  xdg.configFile."herdr/config.toml" = {
    source = (pkgs.formats.toml { }).generate "herdr-config.toml" settings;
    onChange = "${lib.getExe pkgs.unstable.herdr} server reload-config || true";
  };
}
