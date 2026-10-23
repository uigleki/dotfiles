{ inputs, ... }:
{
  flake.modules.nixos.wsl =
    { config, pkgs, ... }:
    {
      imports = [ inputs.nixos-wsl.nixosModules.default ];

      wsl = {
        enable = true;
        defaultUser = config.owner.username;
      };

      environment.systemPackages = [ pkgs.wget ];
    };
}
