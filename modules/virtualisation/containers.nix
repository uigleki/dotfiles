{
  nixos.modules.base =
    { pkgs, ... }:
    {
      environment = {
        persistence."/cache".directories = [ "/var/lib/containers" ];

        systemPackages = [ pkgs.podman-compose ];
      };

      virtualisation.podman = {
        enable = true;
        defaultNetwork.settings.dns_enabled = true;
        dockerCompat = true;
      };
    };

  homeManager.modules.base =
    let
      sessionVariables.DOCKER_HOST = "unix://\${XDG_RUNTIME_DIR}/podman/podman.sock";
    in
    {
      home = {
        inherit sessionVariables;
        persistence."/cache".directories = [ ".local/share/containers" ];
      };

      systemd.user = { inherit sessionVariables; };
    };
}
