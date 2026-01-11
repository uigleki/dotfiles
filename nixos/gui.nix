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
    boot.supportedFilesystems = [ "ntfs" ];

    time.timeZone = "Asia/Shanghai";

    i18n = {
      defaultLocale = "en_US.UTF-8";
      inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5 = {
          addons = with pkgs; [
            qt6Packages.fcitx5-chinese-addons
            fcitx5-pinyin-zhwiki
            fcitx5-pinyin-moegirl
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
            addons.pinyin.globalSection = {
              ShuangpinProfile = "Xiaohe";
            };
            globalOptions."Hotkey/TriggerKeys"."0" = "Super+space";
          };
        };
      };
    };

    networking.networkmanager.enable = true;
    security.rtkit.enable = true; # real-time scheduling for PipeWire
    hardware.bluetooth.enable = true;

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

      # Remap Caps Lock to Home key using keyd
      keyd = {
        enable = true;
        keyboards.default = {
          ids = [ "*" ];
          settings = {
            main = {
              capslock = "home";
            };
          };
        };
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
        sansSerif = [
          "Ubuntu Nerd Font"
          "Noto Sans CJK SC"
        ];
        monospace = [
          "UbuntuMono Nerd Font"
          "Noto Sans Mono CJK SC"
        ];
      };
    };

    environment.systemPackages = with pkgs; [
      wayland-utils
      wl-clipboard
    ];
  };
}
