{
  pkgs,
  user,
  ...
}:
{
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
    openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    curl
    git
    vim
  ];

  users.users.${user.name} = {
    isNormalUser = true;
    initialPassword = user.name;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = user.sshKeys;
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.hostName = user.hostName;
  networking.useDHCP = true;

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "24.05";
}
