{ config, pkgs, ... }:

{
  networking.hostId = "1e29aaf4";
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;

  boot.zfs.extraPools = [ "data" ];
  services.zfs.autoScrub.enable = true;

  services.smartd.enable = true;
  environment.systemPackages = [ pkgs.smartmontools ];
}
