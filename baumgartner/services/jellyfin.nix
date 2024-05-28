{ config, pkgs, ... }:

{
  srvProxy.services = [{ stub = "jf"; port = 8096; }];

  services.jellyfin.enable = true;
}
