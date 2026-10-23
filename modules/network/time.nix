{
  flake.modules.nixos.network.services.chrony = {
    enable = true;
    enableNTS = true;

    # three sources let chrony outvote a bad one
    servers = [
      "nts.netnod.se"
      "ptbtime1.ptb.de"
      "time.cloudflare.com"
    ];
  };
}
