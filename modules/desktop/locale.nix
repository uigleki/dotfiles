{
  flake.modules.nixos.desktop = {
    i18n.extraLocales = [
      "zh_CN.UTF-8/UTF-8"
      "zh_TW.UTF-8/UTF-8"
      "ja_JP.UTF-8/UTF-8"
    ];

    time.timeZone = "Asia/Shanghai";
  };
}
