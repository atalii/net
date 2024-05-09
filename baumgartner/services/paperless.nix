{ pkgs, ... }:
{
  services.paperless.enable = true;
  services.paperless.dataDir = "/data/paperless";
}
