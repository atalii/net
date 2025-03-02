{ pkgs, ... }:

let port = 1819;
in {
  networking.firewall.allowedTCPPorts = [ port ];

  services.miniflux.enable = true;
  services.miniflux.adminCredentialsFile = "/data/secrets/miniflux.env";
  services.miniflux.config = {
    LISTEN_ADDR = "0.0.0.0:${port}";
  };
}
