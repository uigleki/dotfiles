{
  # nixpkgs unstable has services.displayManager.noctalia-greeter, which replaces this whole module once a release ships it
  nixos.modules.desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      package = pkgs.unstable.noctalia-greeter;
    in
    {
      environment.systemPackages = [ package ]; # the shell looks its sync helper up on PATH

      # the shell copies its theme to the greeter on every wallpaper change, which would prompt each time
      security.polkit.extraConfig = ''
        polkit.addRule(function (action, subject) {
          if (action.id == "org.noctalia.greeter.sync-appearance" &&
              action.lookup("program") == "${lib.getExe' package "noctalia-greeter-apply-appearance"}" &&
              action.lookup("user") == "root" &&
              subject.local && subject.active &&
              subject.user == "${config.user.username}") {
            return polkit.Result.YES;
          }
        });
      '';

      services = {
        accounts-daemon.enable = true; # the greeter reads users and avatars from it

        greetd = {
          enable = true;
          settings.default_session.command = lib.getExe' package "noctalia-greeter-session";
        };
      };

      systemd.tmpfiles.packages = [ package ]; # its tmpfiles rule makes the greeter's state directory
    };
}
