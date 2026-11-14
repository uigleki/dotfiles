{
  nixos.modules.desktop =
    { config, pkgs, ... }:
    {
      boot.kernel.sysctl."vm.compaction_proactiveness" = 0; # reduce latency spikes in gaming

      environment.persistence."/cache".users.${config.user.username}.directories = [
        ".local/share/Steam"
        "Games" # Heroic's install directory
      ];

      nixpkgs.config.allowUnfreePackages = [
        "steam"
        "steam-unwrapped"
      ];

      programs = {
        gamemode.enable = true;

        steam = {
          enable = true;
          dedicatedServer.openFirewall = true;
          fontPackages = [ pkgs.wqy_zenhei ];
          localNetworkGameTransfers.openFirewall = true;
          remotePlay.openFirewall = true;
        };
      };

      services.flatpak.packages = [ "com.heroicgameslauncher.hgl" ];
    };
}
