{ pkgs, user, ... }:
{
  time.timeZone = "Asia/Shanghai";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "zh_CN.UTF-8";
      LC_MONETARY = "zh_CN.UTF-8";
    };
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

  users.users.${user.name}.extraGroups = [
    "networkmanager"
    "libvirtd"
    "scanner"
    "lp"
  ];

  hardware = {
    enableRedistributableFirmware = true;
    bluetooth.enable = true;
    sane.enable = true;
    opentabletdriver.enable = true;
    cpu = {
      intel.updateMicrocode = true;
      amd.updateMicrocode = true;
    };
  };

  security.rtkit.enable = true;

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    blueman.enable = true;
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns = true;
    };

    udisks2.enable = true;
    tlp.enable = true;
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

  environment.systemPackages = with pkgs; [
    wayland-utils
    wl-clipboard
    kdePackages.dolphin
    firefox
    konsole
    qbittorrent-enhanced
  ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      ubuntu_font_family
    ];
    fontconfig.defaultFonts = {
      serif = [ "Ubuntu" ];
      sansSerif = [ "Ubuntu" ];
      monospace = [ "Ubuntu Mono" ];
    };
  };
}