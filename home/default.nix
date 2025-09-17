{ user, ... }:
{
  imports = [ ./nix.nix ];

  home = {
    username = user.name;
    homeDirectory = "/home/${user.name}";
  };
}
