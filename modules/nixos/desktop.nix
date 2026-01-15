{
  config,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.myModules.desktop;
in
{
  options.myModules.desktop.enable = lib.mkEnableOption "desktop environment";

  config = lib.mkIf cfg.enable {
    boot.supportedFilesystems = [ "ntfs" ];

    hardware.bluetooth.enable = true;

    time.timeZone = "Asia/Shanghai";

    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocales = [
        "ja_JP.UTF-8/UTF-8"
        "zh_CN.UTF-8/UTF-8"
        "zh_TW.UTF-8/UTF-8"
      ];
      inputMethod = {
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
            addons.pinyin.globalSection = {
              ShuangpinProfile = "Xiaohe";
            };
            globalOptions = {
              "Hotkey/TriggerKeys"."0" = "Super+space";
              Behavior.ShareInputState = "All";
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
        };
      };
    };

    networking.networkmanager.enable = true;

    security.rtkit.enable = true; # real-time scheduling for PipeWire

    users.users.${user.name}.extraGroups = [
      "libvirtd"
      "networkmanager"
    ];

    programs = {
      gamemode.enable = true;
      kdeconnect.enable = true;
      virt-manager.enable = true;

      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        gamescopeSession.enable = true;
        fontPackages = with pkgs; [ wqy_zenhei ];
      };
    };

    services = {
      desktopManager.plasma6.enable = true;
      displayManager.sddm.enable = true;
      flatpak.enable = true;

      # Remap Caps Lock to Home key using keyd
      keyd = {
        enable = true;
        keyboards.default = {
          ids = [ "*" ];
          settings.main.capslock = "home";
        };
      };

      pipewire = {
        enable = true;
        alsa.enable = true;
        jack.enable = true;
        pulse.enable = true;
      };

      sunshine = {
        enable = true;
        capSysAdmin = true;
        openFirewall = true;
      };

      udisks2 = {
        enable = true;
        settings."mount_options.conf".defaults.btrfs_defaults = "compress=zstd,noatime";
      };
    };

    virtualisation = {
      libvirtd.enable = true;
      spiceUSBRedirection.enable = true;
    };

    environment = {
      systemPackages = with pkgs; [
        kitty
        wayland-utils
        wl-clipboard
      ];

      plasma6.excludePackages = with pkgs.kdePackages; [
        baloo-widgets
        khelpcenter
        konsole
        krdp
        plasma-browser-integration
        plasma-workspace-wallpapers
      ];
    };

    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        nerd-fonts.ubuntu
        nerd-fonts.ubuntu-mono
        noto-fonts-cjk-sans
      ];
      fontconfig.defaultFonts = {
        monospace = [
          "UbuntuMono Nerd Font"
          "Noto Sans Mono CJK SC"
        ];
        sansSerif = [
          "Ubuntu Nerd Font"
          "Noto Sans CJK SC"
        ];
      };
    };
  };
}
