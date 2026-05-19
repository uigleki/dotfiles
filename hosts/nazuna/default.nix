{ user, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  myModules = {
    autoUpdate.enable = true;
    server.enable = true;

    hermes = {
      enable = true;
      model = {
        provider = "openrouter";
        default = "deepseek/deepseek-v4-flash:free";
      };
    };
  };

  services.hermes-agent.settings.fallback_model = [
    {
      provider = "opencode-zen";
      model = "deepseek-v4-flash-free";
    }
    {
      provider = "opencode-go";
      model = "deepseek-v4-flash";
    }
    {
      provider = "openrouter";
      model = "deepseek/deepseek-v4-flash";
    }
  ];

  boot = {
    binfmt.emulatedSystems = [ "x86_64-linux" ]; # run x86 binaries on ARM
    loader.timeout = 0; # skip bootloader menu
  };

  # expose syncthing GUI for remote access
  home-manager.users.${user.name}.services.syncthing.guiAddress = "0.0.0.0:8384";
}
