{
  homeManager.modules.base =
    { pkgs, ... }:
    {
      home = {
        # used by coding agents
        packages = with pkgs; [
          # keep-sorted start
          bc
          imagemagick
          poppler-utils
          psmisc
          python3Packages.trafilatura
          tree
          unzip
          # keep-sorted end
        ];

        persistence."/persist".directories = [ ".agents" ]; # skills shared by Claude Code and Codex
      };
    };
}
