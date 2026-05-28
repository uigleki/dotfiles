{ user, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  myModules = {
    autoUpdate.enable = true;
    server.enable = true;

    hermes = {
      enable = true;
      settings = {
        model = {
          provider = "opencode-go";
          default = "deepseek-v4-flash";
        };

        auxiliary.vision = {
          provider = "opencode-go";
          model = "kimi-k2.6";
        };

        web = {
          search_backend = "tavily";
          extract_backend = "firecrawl";
        };

        tts.edge.voice = "zh-CN-XiaoxiaoNeural";
      };
    };
  };

  boot = {
    binfmt.emulatedSystems = [ "x86_64-linux" ]; # run x86 binaries on ARM
    loader.timeout = 0; # skip bootloader menu
  };

  # expose syncthing GUI for remote access
  home-manager.users.${user.name}.services.syncthing.guiAddress = "0.0.0.0:8384";
}
