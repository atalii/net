{ pkgs, ... }:

{
  services.miniflux.enable = true;
  services.miniflux.adminCredentialsFile = "/data/secrets/miniflux.env";
  services.miniflux.config = {
    LISTEN_ADDR = "localhost:1819";
  };
}
