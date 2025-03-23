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

    virtualHosts."tali.network".extraConfig = ''
      respond "Nothing here yet!"
    '';

    virtualHosts."files.tali.network".extraConfig = ''
      root * /data/public
      file_server
    '';

    virtualHosts."auth.tali.network".extraConfig = proxy "localhost" 9091 false;
    virtualHosts."jellyfin.tali.network".extraConfig = proxyBaum 8096 false;
    virtualHosts."code.tali.network".extraConfig = proxyBaum 4444 false;
    virtualHosts."rss.tali.network".extraConfig = proxyBaum 1819 false;
    virtualHosts."cal.tali.network".extraConfig = proxyBaum 8192 false;
    virtualHosts."cabinet.tali.network".extraConfig = proxyBaum 6445 true;

    virtualHosts."ttds.tali.network".extraConfig = proxy "100.90.198.6" 8080 false;

    virtualHosts."wiki.tali.network".extraConfig = ''
      rewrite /favicon.ico /static/art/favicons/tc-logo-green.ico
      rewrite /_assets/favicons/android-chrome-192x192.png /static/art/favicons/tc-logo-green-192x192.png
      rewrite /_assets/favicons/favicon-16x16.png /static/art/favicons/tc-logo-green-48x48.png

      reverse_proxy /static/* https://home.tali.network
      reverse_proxy * http://home.tali.network:3000
    '';
  };

  services.authelia.instances."tla" = {
    enable = true;
    settings = {
      default_2fa_method = "totp";

      # Not doing anything complex with rules yet. Should be two factor soon.
      access_control.default_policy = "one_factor";

      session.cookies = [{
        domain = "tali.network";
        authelia_url = "https://auth.tali.network";
      }];

      # I don't believe Migadu wants me to send email. However,
      # I could self-host an SMTP server just to be used for
      # communication with myself, thereby avoiding most of
      # the complications?
      notifier.filesystem.filename = "/var/lib/authelia-tla/authelia-notifs";
      storage.local.path = "/var/lib/authelia-tla/db.sqlite";
      authentication_backend.file.path = "/var/lib/authelia-tla/users.yml";
    };

    secrets.storageEncryptionKeyFile = "/var/lib/authelia-tla/storage-enc-key";
    secrets.jwtSecretFile = "/var/lib/authelia-tla/jwt-secret";
  };

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "gardiner";
  networking.domain = "";
  services.openssh.enable = true;
  system.stateVersion = "23.11";
}
