{ pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 1819 ];

  services.miniflux.enable = true;
  services.miniflux.adminCredentialsFile = "/data/secrets/miniflux.env";
  services.miniflux.config = {
    LISTEN_ADDR = "0.0.0.0:1819";

    OAUTH2_PROVIDER = "oidc";
    OAUTH2_CLIENT_ID = "6011ce6b-c1b6-4aa2-b9df-cc120ef3eb18";
    OAUTH2_REDIRECT_URL = "https://rss.tali.network/oauth2/oidc/callback";
    OAUTH2_OIDC_DISCOVERY_ENDPOINT = "https://auth.tali.network";
    OAUTH2_USER_CREATION = "1";
  };
}
