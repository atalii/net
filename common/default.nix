{ pkgs, config, ... }:

{
  services.tailscale.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  environment.systemPackages = with pkgs; [
    neofetch # a necessity
    git nvi ghostty.terminfo
  ];

  nixpkgs.config.allowUnfree = true;

  networking.firewall.allowedTCPPorts = [ 80 443 22 ];

  services.borgbackup.jobs."${config.networking.hostName}" = {
    paths = "/home/tali";
    repo = "ssh://tali@100.64.0.1/data/backups/${config.networking.hostName}";
    compression = "auto,zstd";
    startAt = "hourly";

    encryption.mode = "none"; # lol

    # Make sure to use our user (and thereby our SSH key) by default.
    user = "tali";
  };

}
