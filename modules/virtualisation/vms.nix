{
  nixos.modules.desktop =
    { config, ... }:
    {
      environment.persistence = {
        "/cache".directories = [ "/var/lib/libvirt/images" ];

        "/persist".directories = [
          "/var/lib/libvirt"
          "/var/lib/swtpm-localca" # existing vTPMs' EK certificates chain to this CA
        ];
      };

      programs.virt-manager.enable = true;

      # virsh net-autostart default
      systemd.tmpfiles.settings.libvirt-autostart."/var/lib/libvirt/qemu/networks/autostart/default.xml".L.argument =
        "/var/lib/libvirt/qemu/networks/default.xml";

      users.users.${config.user.username}.extraGroups = [ "libvirtd" ];

      virtualisation = {
        libvirtd = {
          enable = true;

          qemu = {
            runAsRoot = false;
            swtpm.enable = true;
          };
        };

        spiceUSBRedirection.enable = true;
      };
    };
}
