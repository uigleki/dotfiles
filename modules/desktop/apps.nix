{
  homeManager.modules.desktop =
    { pkgs, ... }:
    {
      home = {
        packages = with pkgs; [
          cryptomator
          freefilesync
          motrix
        ];

        persistence."/persist".directories = [
          ".config/Cryptomator"
          ".config/FreeFileSync"
          ".config/Motrix"
          ".local/share/Cryptomator"
        ];
      };
    };
}
