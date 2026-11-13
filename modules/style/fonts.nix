{
  nixos.modules.desktop =
    { lib, pkgs, ... }:
    let
      generics = region: rec {
        monospace = [
          "UbuntuMono Nerd Font"
          "Noto Sans Mono CJK ${region}"
        ];

        sans-serif = [
          "Ubuntu Nerd Font"
          "Noto Sans CJK ${region}"
        ];

        serif = sans-serif;
      };

      regions = {
        ja = "JP";
        ko = "KR";
        zh-hk = "HK";
        zh-tw = "TC";
      };

      rule = lang: generic: families: ''
        <match target="pattern">
          <test name="lang" compare="contains"><string>${lang}</string></test>
          <test name="family"><string>${generic}</string></test>
          <edit name="family" mode="prepend" binding="strong">
            ${lib.concatMapStrings (family: "<string>${family}</string>") families}
          </edit>
        </match>
      '';
    in
    {
      fonts = {
        fontconfig = {
          defaultFonts = with generics "SC"; {
            inherit monospace serif;
            sansSerif = sans-serif;
          };

          # fontconfig ranks family order above language, so SC's glyphs would render every CJK language;
          # the regional font outranks SC only by binding strongly and running before the default-fonts alias
          localConf = ''
            <?xml version="1.0"?>
            <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
            <fontconfig>
              ${lib.concatMapAttrsStringSep "" (
                lang: region: lib.concatMapAttrsStringSep "" (rule lang) (generics region)
              ) regions}
            </fontconfig>
          '';
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
