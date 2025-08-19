{
  pkgs,
  config,
  lib,
  ...
}:

{
  options = with lib; {
    backupVar = mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = {
    services.tailscale.enable = true;
    systemd.services.NetworkManager-wait-online.enable = false;

    environment.systemPackages = with pkgs; [
      neofetch # a necessity
      git
      ghostty.terminfo

      python3 # required for ansible
    ];

    nixpkgs.config.allowUnfree = true;

    networking.firewall.allowedTCPPorts = [
      80
      443
      22
    ];

    services.borgbackup.jobs."${config.networking.hostName}" = {
      paths = [
        "/home/tali"
      ]
      ++ lib.optionals config.backupVar [ "/var" ];

      exclude =
        lib.optionals config.backupVar [
          "/var/cache"
          "/var/log"
        ]
        ++ [
          # Borg keeps crying when it needs to back up an sqlite db in here
          # that's actively being modified.
          "/home/tali/.mozilla"

          # Lol.
          "/home/tali/.cache"
        ];

      repo = "ssh://tali@100.64.0.1/data/backups/${config.networking.hostName}";
      compression = "auto,zstd";
      startAt = "daily";

      encryption.mode = "none"; # lol

      # TODO: Unfortunately, we do need to run this as root to read
      # everything in /var. However, there are two precautions to take:
      # 1) On machines that don't have backupVar set, use `tali`
      # 2) Borg can have its own SSH key, potentially one that will give ti a
      #    shell with access limited to /data/backups.
      user = "root";
      environment.BORG_RSH = "ssh -i /home/tali/.ssh/id_ed25519";
    };
  };
}
