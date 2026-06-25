{ pkgs, ... }:
{
  home.packages = [ pkgs.bun ];

  programs.mcp = {
    enable = true;
    servers = {
      context7 = {
        command = "bunx";
        args = [ "@upstash/context7-mcp" ];
      };
    };
  };
}
