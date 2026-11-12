{
  flake.modules = {
    nixos.desktop =
      { config, pkgs, ... }:
      {
        fonts = {
          fontconfig.defaultFonts = {
            monospace = [
              "UbuntuMono Nerd Font"
              "Noto Sans Mono CJK SC"
            ];

            sansSerif = [
              "Ubuntu Nerd Font"
              "Noto Sans CJK SC"
            ];

            serif = config.fonts.fontconfig.defaultFonts.sansSerif;
          };

          packages = with pkgs; [
            nerd-fonts.ubuntu
            nerd-fonts.ubuntu-mono
          ];
        };
      };

    # generic names leave the family to fontconfig above; sizes follow GNOME's defaults
    homeManager.desktop = {
      dconf.settings."org/gnome/desktop/interface" = {
        document-font-name = "Sans Serif 12";
        monospace-font-name = "Monospace 11";
      };

      gtk.font = {
        name = "Sans Serif";
        size = 11;
      };

      # qt6ct parses the quotes; unquoted, QSettings splits the value at the comma
      qt.qt6ctSettings.Fonts = {
        fixed = ''"Monospace,11"'';
        general = ''"Sans Serif,11"'';
      };
    };
  };
}
