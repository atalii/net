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
