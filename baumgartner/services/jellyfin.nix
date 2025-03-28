{ config, pkgs, ... }:

{
  services.jellyfin = {
    enable = true;
    dataDir = "/data/service-state/jellyfin";
  };
}
