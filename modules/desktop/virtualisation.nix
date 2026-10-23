{
  flake.modules.nixos.desktop =
    { config, ... }:
    {
      programs.virt-manager.enable = true;

      # virsh net-autostart default
      systemd.tmpfiles.rules = [
        "L /var/lib/libvirt/qemu/networks/autostart/default.xml - - - - /var/lib/libvirt/qemu/networks/default.xml"
      ];

      users.users.${config.owner.username}.extraGroups = [ "libvirtd" ];

      virtualisation = {
        libvirtd.enable = true;
        spiceUSBRedirection.enable = true;
      };
    };
}
