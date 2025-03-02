{ pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 1819 ];

  services.miniflux.enable = true;
  services.miniflux.adminCredentialsFile = "/data/secrets/miniflux.env";
  services.miniflux.config = {
    LISTEN_ADDR = "0.0.0.0:1819";
  };
}
