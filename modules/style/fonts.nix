{
  nixos.modules.desktop =
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
  homeManager.modules.desktop =
    let
      size = 11;
    in
    {
      dconf.settings."org/gnome/desktop/interface" = {
        document-font-name = "Sans Serif ${toString (size + 1)}";
        monospace-font-name = "Monospace ${toString size}";
      };

      gtk.font = {
        inherit size;
        name = "Sans Serif";
      };

      # qt6ct parses the quotes; unquoted, QSettings splits the value at the comma
      qt.qt6ctSettings.Fonts = {
        fixed = ''"Monospace,${toString size}"'';
        general = ''"Sans Serif,${toString size}"'';
      };
    };
}
