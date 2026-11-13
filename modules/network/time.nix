{
  nixos.modules.network =
    { config, ... }:
    {
      environment.persistence."/persist".directories = [ config.services.chrony.directory ];

      services.chrony = {
        enable = true;
        enableNTS = true;

        # three sources let chrony outvote a bad one
        servers = [
          "nts.netnod.se"
          "ptbtime1.ptb.de"
          "time.cloudflare.com"
        ];
      };
    };
}
