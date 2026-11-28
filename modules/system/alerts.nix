{
  nixos.modules.server =
    { pkgs, ... }:
    {
      systemd = {
        services.healthcheck = {
          description = "Report failed units and low disk space to Healthchecks";
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];
          unitConfig.ConditionPathExists = "/persist/etc/healthcheck-url";
          path = [ pkgs.curl ];

          serviceConfig = {
            DynamicUser = true;
            LoadCredential = "url:/persist/etc/healthcheck-url";
            Type = "oneshot";
          };

          script = ''
            problems=$(
              systemctl --failed --plain --no-legend | cut -d ' ' -f 1

              avail=$(df --output=avail --block-size=1G / | tail -n 1 | tr -dc 0-9)
              if ((avail < 10)); then
                echo "/ has only ''${avail}G free"
              fi
            )

            url=$(<"$CREDENTIALS_DIRECTORY/url")
            if [[ -n $problems ]]; then
              url+=/fail
            fi

            curl --fail --silent --show-error --max-time 10 --retry 5 --data-raw "$problems" "$url"
          '';
        };

        timers.healthcheck = {
          wantedBy = [ "timers.target" ];

          timerConfig = {
            OnBootSec = "5min";
            OnUnitActiveSec = "15min";
          };
        };
      };
    };

  homeManager.modules.desktop =
    { lib, pkgs, ... }:
    let
      check = pkgs.writeShellApplication {
        name = "failed-units";

        runtimeInputs = with pkgs; [
          coreutils
          libnotify
          systemd
        ];

        text = ''
          failed=$(
            {
              systemctl --failed --plain --no-legend
              systemctl --user --failed --plain --no-legend
            } | cut -d ' ' -f 1
          )

          if [[ -n $failed ]]; then
            notify-send --urgency=critical 'Failed units' "$failed"
          fi
        '';
      };
    in
    {
      systemd.user = {
        # repeats until the failure is fixed or cleared with systemctl reset-failed
        services.failed-units = {
          Unit.Description = "Notify about failed units";

          Service = {
            Type = "oneshot";
            ExecStart = lib.getExe check;
          };
        };

        timers.failed-units = {
          Install.WantedBy = [ "graphical-session.target" ];

          Timer = {
            OnActiveSec = "5min";
            OnUnitActiveSec = "1h";
          };

          Unit.PartOf = [ "graphical-session.target" ];
        };
      };
    };
}
