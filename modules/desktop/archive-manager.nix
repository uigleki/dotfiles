{
  homeManager.modules.desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        _7zz # file-roller extracts encrypted 7z and zip with it
        file-roller
        unar # file-roller extracts encrypted rar with it
      ];
    };
}
