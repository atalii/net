{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  programs.adb.enable = true;
  programs.wireshark.enable = true;
  programs.wireshark.usbmon.enable = true;
  users.users.tali.extraGroups = [
    "adbusers"
    "wireshark"
    "plugdev"
  ];

  users.groups.plugdev = { };

  # Stolen from openFPGALoader
  services.udev.extraRules = ''
    # Copy this file to /etc/udev/rules.d/

    ACTION!="add|change", GOTO="openfpgaloader_rules_end"

    # gpiochip subsystem
    SUBSYSTEM=="gpio", MODE="0664", GROUP="plugdev", TAG+="uaccess"

    SUBSYSTEM!="usb|tty|hidraw", GOTO="openfpgaloader_rules_end"

    # Original FT232/FT245 VID:PID
    ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", MODE="664", GROUP="plugdev", TAG+="uaccess"

    # Original FT2232 VID:PID
    ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6010", MODE="664", GROUP="plugdev", TAG+="uaccess"

    # Original FT4232 VID:PID
    ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6011", MODE="664", GROUP="plugdev", TAG+="uaccess"

    # Original FT232H VID:PID
    ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6014", MODE="664", GROUP="plugdev", TAG+="uaccess"

    # Original FT231X VID:PID
    ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6015", MODE="664", GROUP="plugdev", TAG+="uaccess"

    # anlogic cable
    ATTRS{idVendor}=="0547", ATTRS{idProduct}=="1002", MODE="664", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="336c", ATTRS{idProduct}=="1002", MODE="664", GROUP="plugdev", TAG+="uaccess"

    # altera usb-blaster
    ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6001", MODE="664", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6002", MODE="664", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6003", MODE="664", GROUP="plugdev", TAG+="uaccess"

    # altera usb-blasterII - uninitialized
    ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6810", MODE="664", GROUP="plugdev", TAG+="uaccess"
    # altera usb-blasterII - initialized
    ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6010", MODE="664", GROUP="plugdev", TAG+="uaccess"

    # altera usb-blasterIII
    ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6022", MODE="664", GROUP="plugdev", TAG+="uaccess"

    # dirtyJTAG
    ATTRS{idVendor}=="1209", ATTRS{idProduct}=="c0ca", MODE="664", GROUP="plugdev", TAG+="uaccess"

    # Jlink
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="0105", MODE="664", GROUP="plugdev", TAG+="uaccess"

    # NXP LPC-Link2
    ATTRS{idVendor}=="1fc9", ATTRS{idProduct}=="0090", MODE="664", GROUP="plugdev", TAG+="uaccess"

    # NXP ARM mbed
    ATTRS{idVendor}=="0d28", ATTRS{idProduct}=="0204", MODE="664", GROUP="plugdev", TAG+="uaccess"

    # icebreaker bitsy
    ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="6146", MODE="664", GROUP="plugdev", TAG+="uaccess"

    # Radiona ULX3S/ULX4M (DFU)
    ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="614b", MODE="664", GROUP="plugdev", TAG+="uaccess"

    # numato systems
    ATTRS{idVendor}=="2a19", ATTRS{idProduct}=="1009", MODE="644", GROUP="plugdev", TAG+="uaccess"

    # orbtrace-mini dfu
    ATTRS{idVendor}=="1209", ATTRS{idProduct}=="3442", MODE="664", GROUP="plugdev", TAG+="uaccess"

    # QinHeng Electronics USB To UART+JTAG (ch347)
    ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="55dd", MODE="664", GROUP="plugdev", TAG+="uaccess"

    # ESP32-S3 (usb-jtag bridge)
    ATTRS{idVendor}=="303a", ATTRS{idProduct}=="1001", MODE="664", GROUP="plugdev", TAG+="uaccess"

    LABEL="openfpgaloader_rules_end"
  '';

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

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome = {
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

    prismlauncher
  ];

  system.stateVersion = "24.11"; # Did you read the comment?
}
