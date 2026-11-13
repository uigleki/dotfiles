{ inputs, ... }:
{
  nixos.modules.wsl =
    { config, pkgs, ... }:
    {
      imports = [ inputs.nixos-wsl.nixosModules.default ];

      environment.systemPackages = [ pkgs.wget ];

      wsl = {
        enable = true;
        defaultUser = config.user.username;
      };
    };
}
