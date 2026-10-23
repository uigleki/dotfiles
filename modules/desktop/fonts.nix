{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      fonts = {
        enableDefaultPackages = true;

        fontconfig.defaultFonts = {
          monospace = [
            "UbuntuMono Nerd Font"
            "Noto Sans Mono CJK SC"
          ];

          sansSerif = [
            "Ubuntu Nerd Font"
            "Noto Sans CJK SC"
          ];
        };

        packages = with pkgs; [
          nerd-fonts.ubuntu
          nerd-fonts.ubuntu-mono
          noto-fonts-cjk-sans
        ];
      };
    };
}
