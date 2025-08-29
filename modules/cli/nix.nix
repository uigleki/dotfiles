{
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
    randomizedDelaySec = "1s";
  };
}
