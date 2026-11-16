{
  nixos.modules.desktop =
    { pkgs, ... }:
    {
      boot.kernel.sysctl."vm.compaction_proactiveness" = 0; # reduce latency spikes in gaming

      nixpkgs.config.allowUnfreePackages = [
        "steam"
        "steam-unwrapped"
      ];

      programs = {
        gamemode.enable = true;

        steam = {
          enable = true;
          fontPackages = [ pkgs.wqy_zenhei ];
          localNetworkGameTransfers.openFirewall = true;
          remotePlay.openFirewall = true;
        };
      };

      services.flatpak.packages = [ "com.heroicgameslauncher.hgl" ];
    };

  homeManager.modules.desktop.home.persistence = {
    "/persist".directories = [
      ".config/unity3d" # Unity games save here
      ".local/share/Steam/userdata" # local saves and per-game settings
      ".var/app/com.heroicgameslauncher.hgl/config" # store logins and game settings

      # saves of particular games, outside any engine's default
      ".local/share/freebirdgames"
    ];

    "/cache".directories = [
      ".local/share/Steam"
      ".steam"
      ".var/app/com.heroicgameslauncher.hgl/Games"
      ".var/app/com.heroicgameslauncher.hgl/config/heroic/tools" # Wine, Proton and DXVK builds
      "Games" # Heroic's install directory
    ];
  };
}
