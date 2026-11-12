{
  flake.modules = {
    nixos.desktop =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.xwayland-satellite ]; # niri runs X11 apps through it
        programs.niri.enable = true;
        security.pam.services.passwd.enableGnomeKeyring = true; # passwd then re-keys the login keyring too
        services.libinput.enable = true; # on Wayland this only installs libinput's udev rules
      };

    homeManager.desktop =
      { lib, pkgs, ... }:
      {
        # home-manager master has wayland.windowManager.niri, which replaces this file and its validation once a release ships it
        xdg.configFile."niri/config.kdl".source = pkgs.writeTextFile {
          name = "niri-config.kdl";
          checkPhase = ''${lib.getExe pkgs.niri} validate --config "$target"'';
          text = builtins.readFile ./niri.kdl;
        };
      };
  };
}
