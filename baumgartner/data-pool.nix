{ config, pkgs, ... }:

{
  networking.hostId = "1e29aaf4";
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;

  boot.zfs.extraPools = [ "data" ];

  systemd.timers."zfs-scrub-weekly@data".enable = true;
}
