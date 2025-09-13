{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/virtualisation/oci-common.nix")
    ./disk-config.nix
  ];

  boot.loader.timeout = 0;
}
