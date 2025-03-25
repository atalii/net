{ pkgs, lib, ... }: {
  services.unifi = with pkgs; {
    enable = true;
    openFirewall = true;

    unifiPackage = pkgs.unifi;
    mongodbPackage = pkgs.mongodb;
  };

  networking.firewall.allowedTCPPorts = [ 8443 8081 ];
}
