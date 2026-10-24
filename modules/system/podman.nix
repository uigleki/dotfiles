{ config, ... }:
let
  inherit (config) owner;
in
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.podman-compose ];

      # docker compatibility symlink for rootless podman
      systemd.tmpfiles.settings.docker-compat."/run/docker.sock".L.argument =
        "/run/user/${toString owner.uid}/podman/podman.sock";

      virtualisation.podman = {
        enable = true;
        defaultNetwork.settings.dns_enabled = true;
        dockerCompat = true;
      };
    };
}
