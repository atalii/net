{ config, pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "baumgartner";

  networking.networkmanager.enable = true;

  time.timeZone = "America/Denver";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [
    "root"
    "atalii"
  ];

  environment.systemPackages = with pkgs; [
    zfs
    dig
    borgbackup
  ];

  # I don't *think* there's any important state in /var (excepting perhaps
  # Jellyfin playlist info), but I don't want to find out I'm wrong the hard
  # way.
  backupVar = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  users.users."code-server".home = "/data/code-home";

  services.journald.extraConfig = ''
    SystemMaxUse=1G
  '';

  imports = [
    ./services
    ./hardware-configuration.nix
    ./data-pool.nix
  ];

  services.nullmailer = {
    enable = true;

    remotesFile = "/data/nullmailer/remotes";
    config = {
      me = "tali.network";
      allmailfrom = "net@tali.network";
    };
  };

  system.stateVersion = "23.11";
}
