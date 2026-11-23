{
  nixos.modules.desktop =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.xwayland-satellite ]; # niri runs X11 apps through it
      programs.niri.enable = true;
      services.libinput.enable = true; # on Wayland this only installs libinput's udev rules
    };

  homeManager.modules.desktop =
    { lib, pkgs, ... }:
    {
      # TODO: on 26.11, use the native module and take the cursor theme and size from home.pointerCursor
      xdg.configFile."niri/config.kdl".source = pkgs.writeTextFile {
        name = "niri-config.kdl";
        text = builtins.readFile ./niri.kdl;
        checkPhase = ''${lib.getExe pkgs.niri} validate --config "$target"'';
      };
    };
}
