{
  homeManager.modules.desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        cryptomator
        freefilesync
        motrix
      ];
    };
}
