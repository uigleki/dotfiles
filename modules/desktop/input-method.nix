{
  flake.modules = {
    nixos.desktop =
      { pkgs, ... }:
      {
        i18n.inputMethod = {
          enable = true;
          type = "fcitx5";

          fcitx5 = {
            addons = with pkgs; [
              fcitx5-mozc
              fcitx5-pinyin-moegirl
              fcitx5-pinyin-zhwiki
              qt6Packages.fcitx5-chinese-addons
            ];

            settings = {
              addons.pinyin.globalSection.ShuangpinProfile = "Xiaohe";

              globalOptions = {
                Behavior.ShareInputState = "All";
                "Hotkey/TriggerKeys"."0" = "Super+space";
              };

              inputMethod = {
                "Groups/0" = {
                  Name = "Default";
                  "Default Layout" = "us";
                };

                "Groups/0/Items/0".Name = "keyboard-us";
                "Groups/0/Items/1".Name = "shuangpin";
              };
            };

            waylandFrontend = true;
          };
        };

        nixpkgs.config.allowUnfreePackages = [ "fcitx5-pinyin-moegirl" ]; # dictionary data is CC BY-NC-SA
      };

    # prevent fcitx5 warning about missing virtual keyboard
    homeManager.desktop.programs.plasma.configFile.kwinrc.Wayland.InputMethod =
      "/run/current-system/sw/share/applications/org.fcitx.Fcitx5.desktop";
  };
}
