{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.myModules.gui;
in
{
  options.myModules.gui.enable = lib.mkEnableOption "Enable GUI configuration";

  config = lib.mkIf cfg.enable {
    time.timeZone = "Asia/Shanghai";

    i18n = {
      defaultLocale = "en_US.UTF-8";
      inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5.addons = with pkgs; [
          fcitx5-rime
          qt6Packages.fcitx5-chinese-addons
          fcitx5-gtk
          fcitx5-pinyin-zhwiki
          fcitx5-pinyin-moegirl
        ];
      };
    };

    networking.networkmanager.enable = true;
    security.rtkit.enable = true; # real-time scheduling for PipeWire

    hardware = {
      enableRedistributableFirmware = true;
      bluetooth.enable = true;
    };

    users.users.${user.name}.extraGroups = [
      "networkmanager"
      "libvirtd"
    ];

    services = {
      desktopManager.plasma6.enable = true;
      displayManager.sddm.enable = true;
      pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
        jack.enable = true;
      };
    };

    virtualisation = {
      libvirtd.enable = true;
      spiceUSBRedirection.enable = true;
    };

    programs = {
      virt-manager.enable = true;
      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        gamescopeSession.enable = true;
        fontPackages = with pkgs; [ wqy_zenhei ];
      };
      gamemode.enable = true;
    };

    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        noto-fonts-cjk-sans
        nerd-fonts.ubuntu
        nerd-fonts.ubuntu-mono
      ];
      fontconfig.defaultFonts = {
        sansSerif = [ "Ubuntu" ];
        monospace = [ "Ubuntu Mono" ];
      };
    };

    environment.systemPackages = with pkgs; [
      wayland-utils
      wl-clipboard
    ];
  };
}
