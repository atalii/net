{ ... }:

let
  baumgartner = "100.64.0.1";
  proxy = host: port: auth: (if auth then ''
    forward_auth localhost:9091 {
      uri /api/authz/forward-auth
      copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
    }
  '' else "") + ''
    reverse_proxy * "http://${host}:${toString port}"
  '';

  proxyBaum = proxy baumgartner;
in {
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

    virtualHosts."code.tali.network".extraConfig = proxyBaum 4444 true;
    virtualHosts."rss.tali.network".extraConfig = proxyBaum 1819 false;
    virtualHosts."cal.tali.network".extraConfig = proxyBaum 8192 false;
    virtualHosts."cabinet.tali.network".extraConfig = proxyBaum 6445 true;

    virtualHosts."ttds.tali.network".extraConfig = proxy "100.90.198.6" 8080 false;

    virtualHosts."wiki.tali.network".extraConfig = ''
      rewrite /favicon.ico /static/art/favicons/tc-logo-green.ico
      rewrite /_assets/favicons/android-chrome-192x192.png /static/art/favicons/tc-logo-green-192x192.png
      rewrite /_assets/favicons/favicon-16x16.png /static/art/favicons/tc-logo-green-48x48.png

      reverse_proxy * http://${baumgartner}:3000
    '';
  };

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  services.journald.extraConfig = ''
    SystemMaxUse=400M
  '';

  networking.hostName = "gardiner";
  networking.domain = "";
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  system.stateVersion = "23.11";
}
