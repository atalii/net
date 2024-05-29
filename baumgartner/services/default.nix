{ config, pkgs, ... }:

{
  srvProxy.services = [ { stub = "cc"; port = 3633; } ];
  srvProxy.blocks = [ "youtube.com" "m.youtube.com" "reddit.com" ];

  imports = [
    ./jellyfin.nix ./postgres.nix ./wikijs.nix ./imhdss.nix ./radicale.nix ./paperless.nix ./miniflux.nix
  ];

  services.distccd.enable = true;
  services.distccd.allowedClients = [ "127.0.0.1" "100.64.0.0/10" "192.168.0.0/16" ];
  services.distccd.openFirewall = true;
  services.distccd.stats.enable = true;
  services.distccd.logLevel = "info";
  environment.systemPackages = with pkgs; [ gcc clang ];
}
