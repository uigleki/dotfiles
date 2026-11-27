{ config, ... }:
let
  inherit (config) user;
  heroic = "com.heroicgameslauncher.hgl";
  backups = "~/${user.dirs.ludusavi}";
in
{
  nixos.modules.desktop = {
    boot.kernel.sysctl."vm.compaction_proactiveness" = 0; # reduce latency spikes in gaming

    nixpkgs.config.allowUnfreePackages = [
      "steam"
      "steam-unwrapped"
    ];

    programs = {
      gamemode.enable = true;

      steam = {
        enable = true;
        localNetworkGameTransfers.openFirewall = true;
        remotePlay.openFirewall = true;
      };
    };

    services.flatpak = {
      packages = [ heroic ];
      overrides.settings.${heroic}.Context.filesystems = [ "~/${user.dirs.games}" ];
    };
  };

  homeManager.modules.desktop = {
    home.persistence = {
      "/cache".directories = [
        ".config/ludusavi" # the downloaded manifest of save locations
        ".local/share/Steam"
        ".local/share/umu" # the Steam Runtime that Heroic runs Proton in
        ".steam"
        ".var/app/${heroic}/cache"
        ".var/app/${heroic}/config/heroic/tools" # Wine, Proton and DXVK builds
        "Games" # Heroic's install directory
      ];

      "/persist".directories = [
        ".config/unity3d" # Unity games save here
        ".local/share/Steam/userdata" # local saves and per-game settings
        ".var/app/${heroic}" # store logins and game settings

        # saves of particular games, outside any engine's default
        ".local/share/freebirdgames"
      ];
    };

    services.ludusavi = {
      enable = true;

      settings = {
        backup = {
          onlyConstructive = true;
          path = backups;

          retention = {
            full = 2;
            differential = 2;
          };
        };

        release.check = false;
        restore.path = backups;

        roots = [
          {
            path = "~/.local/share/Steam";
            store = "steam";
          }
          {
            path = "~/.var/app/${heroic}/config/heroic";
            store = "heroic";
          }
        ];
      };
    };

    systemd.user.timers.ludusavi.Timer.Persistent = true;
  };
}
