{ userConfig, ... }:
let
  envs = builtins.concatStringsSep " + " (builtins.attrNames userConfig.env);
  appendEnvs =
    builtins.trace "user append envs: *** ${envs} ***" userConfig.env;
in {
  home.sessionVariables = {
    # hello = "world";
  } // appendEnvs;
}
