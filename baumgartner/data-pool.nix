{ lib, pkgs, ... }:

{
  networking.hostId = "1e29aaf4";
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;

  boot.zfs.extraPools = [ "data" ];
  services.zfs.autoScrub.enable = true;

  services.smartd.enable = true;
  environment.systemPackages = [ pkgs.smartmontools ];

  # Systemd considers oneshots up after they finish, which lets us
  # orderzfs-notify on it.
  systemd.services.zfs-scrub.serviceConfig.Type = lib.mkForce "oneshot";
  systemd.services.zfs-notify = {
    description = "Send an email regarding the ZFS scrub.";
    after = [ "zfs-scrub.service" ];
    wantedBy = [ "zfs-scrub.service" ];
    serviceConfig = {
      Type = "oneshot";

      # We do this instead of enabling the sendmail wrapper for... no good
      # reason. (The spool is nullmailer:nullmailer.)
      User = "nullmailer";
      Group = "nullmailer";
    };

    script = ''
      ${pkgs.nullmailer}/bin/sendmail \
        -f 'net@tali.network' \
        -F 'zfs-notify.service' \
        me@tali.network <<EOF
      Subject: ZFS Scrub Results

      $(${pkgs.zfs}/bin/zpool status -v)
      EOF
    '';
  };

}
