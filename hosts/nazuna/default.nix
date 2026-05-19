{ inputs, user, ... }:
{
  imports = [
    inputs.hermes-agent.nixosModules.default
    ./hardware-configuration.nix
  ];

  myModules = {
    autoUpdate.enable = true;
    server.enable = true;
  };

  boot = {
    binfmt.emulatedSystems = [ "x86_64-linux" ]; # run x86 binaries on ARM
    loader.timeout = 0; # skip bootloader menu
  };

  # expose syncthing GUI for remote access
  home-manager.users.${user.name}.services.syncthing.guiAddress = "0.0.0.0:8384";

  # required secrets – replace values and run:
  #   sudo -u hermes tee /var/lib/hermes/.hermes/.env >/dev/null <<'EOF'
  #   OPENROUTER_API_KEY=sk-or-v1-xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  #   TELEGRAM_BOT_TOKEN=1234567890:ABCdefGHIjklmNOPqrstUVwxyz
  #   TELEGRAM_ALLOWED_USERS=123456789
  #   EOF
  services.hermes-agent = {
    enable = true;
    addToSystemPackages = true;
    extraDependencyGroups = [ "messaging" ];

    settings = {
      model = "deepseek/deepseek-v4-flash";
      telegram.reactions = true;
    };
  };
}
