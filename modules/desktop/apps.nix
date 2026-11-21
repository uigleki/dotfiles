{
  homeManager.modules.desktop =
    { pkgs, ... }:
    {
      home = {
        packages = with pkgs; [
          cryptomator
          freefilesync
        ];

        persistence."/persist".directories = [
          ".config/Cryptomator"
          ".config/FreeFileSync"
          ".local/share/Cryptomator"
        ];
      };
    };
}
