{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect

  ];

  services.tailscale.useRoutingFeatures = "server";

  services.gotosocial = {
    enable = true;
    settings = {
      protocol = "https";
      host = "fedi.tali.network";
      accounts-allow-custom-css = true;
    };
  };

  services.caddy = {
    enable = true;
    virtualHosts."fedi.tali.network".extraConfig = ''
      reverse_proxy * http://127.0.0.1:8080 {
          flush_interval -1
      }
    '';

    virtualHosts."tali.network".extraConfig = ''
      respond "Nothing here yet!"
    '';

    virtualHosts."files.tali.network".extraConfig = ''
      root * /data/public
      file_server
    '';

    virtualHosts."jellyfin.tali.network".extraConfig = ''
      reverse_proxy * https://jf-home.tali.network {
        header_up Host "jf-home.tali.network"
      }
    '';

    virtualHosts."code.tali.network".extraConfig = ''
      reverse_proxy * http://home.tali.network:4444
    '';

    virtualHosts."rss.tali.network".extraConfig = ''
      reverse_proxy * http://home.tali.network:1819
    '';

    virtualHosts."wiki.tali.network".extraConfig = ''
      rewrite /favicon.ico /static/art/favicons/tc-logo-green.ico
      rewrite /_assets/favicons/android-chrome-192x192.png /static/art/favicons/tc-logo-green-192x192.png
      rewrite /_assets/favicons/favicon-16x16.png /static/art/favicons/tc-logo-green-48x48.png

      reverse_proxy /static/* https://home.tali.network
      reverse_proxy * http://home.tali.network:3000
    '';

    virtualHosts."cal.tali.network".extraConfig = ''
      reverse_proxy * http://100.64.0.1:8192
    '';

    virtualHosts."ttds.tali.network".extraConfig = ''
      reverse_proxy * http://100.90.198.6:8080
    '';
  };

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "gardiner";
  networking.domain = "";
  services.openssh.enable = true;
  system.stateVersion = "23.11";
}
