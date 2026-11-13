{ inputs, ... }:
{
  nixos.modules.auto-upgrade.system.autoUpgrade = {
    enable = true;
    allowReboot = true;

    # only nixpkgs floats past the lock: the stable channel is where security fixes land
    flags = [
      "--override-input"
      "nixpkgs"
      (import "${inputs.self}/flake.nix").inputs.nixpkgs.url
    ];

    flake = inputs.self.outPath;
    upgrade = false; # --upgrade only updates channels
  };
}
