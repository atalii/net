{ pkgs, lib, ... }: {
  srvProxy.services = [{
    stub = "uf";
    port = 8443;
    https = true;
  }];

  services.unifi = with pkgs; {
    enable = true;
    openFirewall = true;

    unifiPackage = pkgs.unifi;
    mongodbPackage = pkgs.mongodb;
  };

  networking.firewall.allowedTCPPorts = [ 8443 8081 ];
}
