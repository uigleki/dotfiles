{
  flake.modules.nixos.desktop =
    { config, ... }:
    {
      programs.virt-manager.enable = true;

      # virsh net-autostart default
      systemd.tmpfiles.settings.libvirt-autostart."/var/lib/libvirt/qemu/networks/autostart/default.xml".L.argument =
        "/var/lib/libvirt/qemu/networks/default.xml";

      users.users.${config.owner.username}.extraGroups = [ "libvirtd" ];

      virtualisation = {
        libvirtd.enable = true;
        spiceUSBRedirection.enable = true;
      };
    };
}
