{ config, ... }:
let
  inherit (config) user;
in
{
  nixos.modules.base =
    { config, pkgs, ... }:
    {
      environment = {
        persistence."/cache" = {
          directories = [ "/var/lib/containers" ];
          users.${config.user.username}.directories = [ ".local/share/containers" ];
        };

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
