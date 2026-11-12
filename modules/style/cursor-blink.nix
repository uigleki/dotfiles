{
  homeManager.modules.desktop = {
    dconf.settings."org/gnome/desktop/interface".cursor-blink = false;

    programs = {
      kitty.settings.cursor_blink_interval = 0;
      zed-editor.userSettings.cursor_blink = false;
    };

    qt.qt6ctSettings.Interface.cursor_flash_time = 0;
  };
}
