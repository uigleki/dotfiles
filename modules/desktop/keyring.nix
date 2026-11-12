{
  # niri's module runs gnome-keyring; with this, passwd re-keys the login keyring too
  nixos.modules.desktop.security.pam.services.passwd.enableGnomeKeyring = true;
}
