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
  options.myModules.gui.enable = lib.mkEnableOption "GUI configuration";

  config = lib.mkIf cfg.enable {
    time.timeZone = "Asia/Shanghai";

    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings.LC_TIME = "zh_CN.UTF-8";
      inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5.addons = with pkgs; [
          fcitx5-rime
          fcitx5-chinese-addons
          fcitx5-gtk
        ];
      };
    };

    networking.networkmanager.enable = true;
    security.rtkit.enable = true;

    hardware = {
      enableRedistributableFirmware = true;
      graphics.enable = true;
      bluetooth.enable = true;
      sane.enable = true;
      opentabletdriver.enable = true;
      cpu = {
        intel.updateMicrocode = true;
        amd.updateMicrocode = true;
      };
    };

    users.users.${user.name}.extraGroups = [
      "networkmanager"
      "libvirtd"
      "scanner"
      "lp"
    ];

    services = {
      desktopManager.plasma6.enable = true;
      displayManager.sddm.enable = true;

      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };

      printing.enable = true;
      avahi = {
        enable = true;
        nssmdns4 = true;
      };

      fprintd.enable = true;
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
      };
    };

    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [ ubuntu_font_family ];
      fontconfig.defaultFonts = {
        sansSerif = [ "Ubuntu" ];
        monospace = [ "Ubuntu Mono" ];
      };
    };

    environment.systemPackages = with pkgs; [
      firefox
      qbittorrent-enhanced
      wayland-utils
      wl-clipboard
    ];
  };
}
