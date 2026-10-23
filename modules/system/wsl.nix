{ inputs, ... }:
{
  flake.modules.nixos.wsl =
    { config, pkgs, ... }:
    {
      imports = [ inputs.nixos-wsl.nixosModules.default ];

      environment.systemPackages = [ pkgs.wget ];

      wsl = {
        enable = true;
        defaultUser = config.owner.username;
      };
    };
}
