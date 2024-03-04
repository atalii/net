{ pkgs, config, ... }:

{
  services.tailscale.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  environment.systemPackages = with pkgs; [ neofetch ]; # a necessity
}
