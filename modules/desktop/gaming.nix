{
  flake.modules.nixos.desktop =
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
          dedicatedServer.openFirewall = true;
          fontPackages = with pkgs; [ wqy_zenhei ];
          localNetworkGameTransfers.openFirewall = true;
          remotePlay.openFirewall = true;
        };
      };
    };
}
