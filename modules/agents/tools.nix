{
  homeManager.modules.base =
    { pkgs, ... }:
    {
      # used by coding agents
      home.packages = with pkgs; [
        bc
        imagemagick
        lsof
        poppler-utils
        psmisc
        python3Packages.trafilatura
        tree
        unzip
      ];
    };
}
