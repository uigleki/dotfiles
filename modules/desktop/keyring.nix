{
  nixos.modules.desktop =
    { lib, ... }:
    {
      # niri's module runs gnome-keyring; with this, passwd re-keys the login keyring too
      security.pam.services.passwd = {
        enableGnomeKeyring = true;
        # upstream makes unix "sufficient", which ends the stack before gnome_keyring runs
        rules.password.unix.control = lib.mkForce "required";
      };
    };
}
