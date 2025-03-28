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
}
