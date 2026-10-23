{
  flake.modules = {
    nixos.desktop =
      { pkgs, ... }:
      {
        i18n.inputMethod = {
          enable = true;
          type = "fcitx5";

          fcitx5 = {
            waylandFrontend = true;

            addons = with pkgs; [
              qt6Packages.fcitx5-chinese-addons
              fcitx5-pinyin-zhwiki
              fcitx5-pinyin-moegirl
              fcitx5-mozc
            ];

            settings = {
              inputMethod = {
                "Groups/0" = {
                  Name = "Default";
                  "Default Layout" = "us";
                };

                "Groups/0/Items/0".Name = "keyboard-us";
                "Groups/0/Items/1".Name = "shuangpin";
              };

              addons.pinyin.globalSection.ShuangpinProfile = "Xiaohe";

              globalOptions = {
                "Hotkey/TriggerKeys"."0" = "Super+space";
                Behavior.ShareInputState = "All";
              };
            };
          };
        };

        nixpkgs.config.allowUnfreePackages = [ "fcitx5-pinyin-moegirl" ]; # dictionary data is CC BY-NC-SA
      };

    # prevent fcitx5 warning about missing virtual keyboard
    homeManager.desktop.programs.plasma.configFile.kwinrc.Wayland.InputMethod =
      "/run/current-system/sw/share/applications/org.fcitx.Fcitx5.desktop";
  };
}
