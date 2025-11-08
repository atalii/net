{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  networking.interfaces = {
    enp193s0f3u1 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.0.1";
          prefixLength = 24;
        }
      ];
    };
  };

  programs.adb.enable = true;
  programs.wireshark.enable = true;
  programs.wireshark.usbmon.enable = true;
  users.users.tali.extraGroups = [
    "adbusers"
    "wireshark"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  boot.tmp.useTmpfs = true;

  networking.hostName = "thing-in-itself";
  networking.networkmanager.enable = true;

  networking.hosts = {
    "0.0.0.0" = [
      # "youtube.com"
      # "www.youtube.com"
    ];
  };

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

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome = {
    enable = true;
    extraGSettingsOverridePackages = [ pkgs.mutter ];
    extraGSettingsOverrides = ''
      [org.gnome.mutter]
      experimental-features=['scale-monitor-framebuffer']
    '';
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [ hplipWithPlugin ];
  };
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.postgresql.enable = true;

  programs.firefox.enable = true;

  programs.chrysalis.enable = true;

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];

  environment.systemPackages = with pkgs; [
    git
    wireshark
  ];

  system.stateVersion = "24.11"; # Did you read the comment?
}
