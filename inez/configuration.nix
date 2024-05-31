# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./power.nix
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "inez";
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

  programs.wayfire = {
    enable = true;
    plugins = with pkgs.wayfirePlugins; [
      wayfire-plugins-extra wf-shell
    ];
  };

  services.xserver.enable = true;
  services.displayManager.sddm = with pkgs; {
    enable = true;

    package = kdePackages.sddm;
    theme = "breeze";
    wayland.compositor = "kwin";
    extraPackages = with kdePackages; [
        breeze-icons
        kirigami
        plasma5support
        qtsvg
        qtvirtualkeyboard
      ];
  };

  services.gnome.gnome-keyring.enable = true;

  virtualisation.docker.enable = true;

  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  services.printing.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.users.atalii = {
    isNormalUser = true;
    description = "Tali Auster";
    extraGroups = [ "networkmanager" "wheel" "docker" "audio" ];
    shell = pkgs.nushell;
  };

  environment.systemPackages = with pkgs; [
    eww
    firefox chromium thunderbird
    git distcc gcc
  ];

  environment.etc."adage.conf".text = ''
    permit g!wheel as root
  '';

  environment.variables.DISTCC_POTENTIAL_HOSTS = "localhost home.tali.network";

  fonts.packages = with pkgs; [ ibm-plex input-fonts ];
  nixpkgs.config.input-fonts.acceptLicense = true;

  services.openssh.enable = true;

  system.stateVersion = "23.11"; # Did you read the comment?
}
