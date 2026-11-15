{
  homeManager.modules.base =
    { pkgs, ... }:
    {
      home = {
        # used by coding agents
        packages = with pkgs; [
          bc
          imagemagick
          lsof
          poppler-utils
          psmisc
          python3Packages.trafilatura
          tree
          unzip
        ];

        persistence."/persist".directories = [ ".agents" ]; # skills shared by Claude Code and Codex
      };
    };
}
