{
  flake.modules.nixos.desktop =
    { config, ... }:
    {
      programs.virt-manager.enable = true;

      users.users.${config.owner.username}.extraGroups = [ "libvirtd" ];

      virtualisation = {
        libvirtd.enable = true;
        spiceUSBRedirection.enable = true;
      };
    };
}
