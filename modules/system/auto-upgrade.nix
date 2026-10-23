{ inputs, ... }:
{
  flake.modules.nixos.auto-upgrade.system.autoUpgrade = {
    enable = true;
    allowReboot = true;

    flags = [
      # update flake inputs without modifying the repo's lock file
      "--recreate-lock-file"
      "--no-write-lock-file"
    ];

    flake = inputs.self.outPath;
    upgrade = false; # --upgrade only updates channels
  };
}
