{
  nixos.modules.server =
    { lib, pkgs, ... }:
    let
      # the mode variables are set by deploy-rs's activate binary and specified only in its source
      activate = pkgs.writeShellScript "deploy-rs-activate" ''
        if [[ ''${DRY_ACTIVATE:-} == 1 ]]; then
          action=dry-activate
        elif [[ ''${BOOT:-} == 1 ]]; then
          action=boot
        elif [[ ''${TEST:-} == 1 ]]; then
          action=test
        else
          action=switch
        fi

        exec "$PROFILE/bin/switch-to-configuration" "$action"
      '';
    in
    {
      # a deploy-rs rollback runs the previous generation's hook, and that generation may be the nightly upgrade's
      system.systemBuilderCommands = ''
        ln -s ${activate} $out/deploy-rs-activate
        ln -s ${lib.getExe' pkgs.deploy-rs "activate"} $out/activate-rs
      '';
    };
}
