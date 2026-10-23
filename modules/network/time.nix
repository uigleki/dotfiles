{
  flake.modules.nixos.network.services.chrony = {
    enable = true;
    enableNTS = true;
    # three sources let chrony outvote a bad one
    servers = [
      "time.cloudflare.com"
      "nts.netnod.se"
      "ptbtime1.ptb.de"
    ];
  };
}
