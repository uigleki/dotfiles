{
  nixos.modules.desktop =
    { config, ... }:
    {
      environment.persistence."/persist".directories = [ "/var/lib/libvirt" ];
      programs.virt-manager.enable = true;

      # virsh net-autostart default
      systemd.tmpfiles.settings.libvirt-autostart."/var/lib/libvirt/qemu/networks/autostart/default.xml".L.argument =
        "/var/lib/libvirt/qemu/networks/default.xml";

      users.users.${config.user.username}.extraGroups = [ "libvirtd" ];

      virtualisation = {
        libvirtd.enable = true;
        spiceUSBRedirection.enable = true;
      };
    };
}
