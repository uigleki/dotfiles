{ config, ... }:
let
  inherit (config) user;
in
{
  nixos.modules.base =
    { pkgs, ... }:
    {
      environment = {
        persistence."/persist".directories = [ "/var/lib/containers" ];
        systemPackages = [ pkgs.podman-compose ];
      };

      # docker compatibility symlink for rootless podman
      systemd.tmpfiles.settings.docker-compat."/run/docker.sock".L.argument =
        "/run/user/${toString user.uid}/podman/podman.sock";

      virtualisation.podman = {
        enable = true;
        defaultNetwork.settings.dns_enabled = true;
        dockerCompat = true;
      };
    };
}
