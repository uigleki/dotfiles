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
    boot = {
      kernelPackages = pkgs.linuxPackages_zen;
      supportedFilesystems = [ "ntfs" ];
      kernel.sysctl = {
        "vm.compaction_proactiveness" = 0; # reduce latency spikes in gaming
      };
    };

    environment = {
      systemPackages = with pkgs; [
        kitty
        wl-clipboard
      ];

      plasma6.excludePackages = with pkgs.kdePackages; [
        baloo-widgets
        discover
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

    hardware.bluetooth.enable = true;

    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocales = [
        "zh_CN.UTF-8/UTF-8"
        "zh_TW.UTF-8/UTF-8"
        "ja_JP.UTF-8/UTF-8"
      ];

      inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5 = {
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
    };

    networking.networkmanager.enable = true;

    programs = {
      gamemode.enable = true;
      kdeconnect.enable = true;
      virt-manager.enable = true;

      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        fontPackages = with pkgs; [ wqy_zenhei ];
      };
    };

    # real-time scheduling for PipeWire
    security.rtkit.enable = true;

    services = {
      desktopManager.plasma6.enable = true;
      displayManager.sddm.enable = true;
      flatpak.enable = true;

      # remap Caps Lock to Home key using keyd
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

      scx = {
        enable = true;
        scheduler = "scx_lavd";
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

    time.timeZone = "Asia/Shanghai";

    users.users.${user.name}.extraGroups = [
      "libvirtd"
      "networkmanager"
    ];

    virtualisation = {
      libvirtd.enable = true;
      spiceUSBRedirection.enable = true;
    };
  };
}
