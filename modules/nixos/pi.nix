# required secrets – replace value and run:
#  printf '%s\n' \
#  'OPENCODE_API_KEY=sk-ABCdef123...' \
#  | sudo install -o pi -g pi -m 0640 /dev/stdin /var/lib/pi/.env

{
  config,
  inputs,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.myModules.pi;
  home = "/var/lib/pi";
  name = "pi";
  settingsFormat = pkgs.formats.json { };

  pi = pkgs.buildNpmPackage {
    pname = "pi";
    version = inputs.pi.shortRev or "dirty";
    src = inputs.pi;

    npmDeps = pkgs.importNpmLock { npmRoot = inputs.pi; };
    npmConfigHook = pkgs.importNpmLock.npmConfigHook;

    nativeBuildInputs = [ pkgs.makeWrapper ];

    installPhase = ''
      mkdir -p $out/bin $out/lib/pi
      cp -r packages/coding-agent/dist $out/lib/pi/

      makeWrapper ${lib.getExe pkgs.nodejs} $out/bin/pi \
        --add-flags "$out/lib/pi/dist/cli.js" \
        --prefix PATH : ${
          lib.makeBinPath [
            pkgs.nodejs
            pkgs.git
          ]
        }
    '';

    meta.mainProgram = "pi";
  };
in
{
  options.myModules.pi = {
    enable = lib.mkEnableOption "Pi Agent";

    settings = lib.mkOption {
      inherit (settingsFormat) type;
      description = "Pi settings written to ~/.pi/agent/settings.json on activation.";
      default = { };

      example = {
        defaultProvider = "opencode-go";
        defaultModel = "deepseek-v4-flash";
      };
    };

    plugins = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "npm packages to install as Pi extensions.";
      default = [ ];

      example = [
        "pi-subagents"
        "pi-web-access"
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      groups.${name} = { };

      users = {
        ${name} = {
          inherit home;
          isSystemUser = true;
          group = name;
          createHome = true;
        };

        ${user.name}.extraGroups = [ name ];
      };
    };

    systemd = {
      tmpfiles.rules = [ "d ${home} 2770 ${name} ${name} - -" ];

      services."${name}-agent" = {
        description = "Pi Agent";
        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];

        environment.HOME = home;

        path = [
          pi
          pkgs.bash
          pkgs.coreutils
          pkgs.git
          pkgs.nodejs
        ];

        serviceConfig = {
          User = name;
          Group = name;
          WorkingDirectory = home;
          EnvironmentFile = [ "${home}/.env" ];
          ExecStart = "${pi}/bin/pi";
          Restart = "on-failure";
          RestartSec = 5;
          UMask = "0007";
          NoNewPrivileges = true;
          ProtectHome = false;
          ProtectSystem = "strict";
          PrivateTmp = true;
          ReadWritePaths = [ home ];
        };
      };
    };

    system.activationScripts."${name}-setup" = lib.stringAfter [ "users" ] ''
      cfgDir=${home}/.pi/agent
      target="$cfgDir/settings.json"
      mkdir -p "$cfgDir"
      generated=${settingsFormat.generate "settings.json" cfg.settings}
      if [ -f "$target" ]; then
        ${pkgs.jq}/bin/jq -s '.[0] * .[1]' "$target" "$generated" > "$target.tmp"
        mv "$target.tmp" "$target"
      else
        install -m 644 "$generated" "$target"
      fi
      chown ${name}:${name} "$target"
      ${lib.concatStringsSep "\n" (
        map (p: ''
          d=${home}/.pi/agent/npm/node_modules/${p}
          [ -d "$d" ] || ${pkgs.shadow}/bin/runuser -u ${name} -- ${pi}/bin/pi install "npm:${p}"
        '') cfg.plugins
      )}
    '';
  };
}
