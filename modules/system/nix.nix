{ inputs, ... }:
{
  flake.modules.nixos.base = {
    nix = {
      channel.enable = false;

      settings = {
        auto-optimise-store = true;

        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
    };

    nixpkgs.overlays = [
      # expose unstable packages as pkgs.unstable.*, sharing the unfree allowlist
      (final: _: {
        unstable = import inputs.nixpkgs-unstable {
          inherit (final) config;
          inherit (final.stdenv.hostPlatform) system;
        };
      })
    ];

    # remove legacy channel profiles (flakes-only configuration)
    systemd.tmpfiles.settings.remove-channels."/nix/var/nix/profiles/per-user/root/channels*".R = { };
  };
}
