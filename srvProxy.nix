{ config, pkgs, lib, ... }:

{
  options.srvProxy.services = with lib; mkOption {
    description = "Descriptions of web services to proxy.";
    type = with types; listOf (attrsOf anything);
    default = [];
  };

  config = let
  
    common = ''
      tls /var/lib/caddy/tali.network-ssl-bundle/domain.cert.pem /var/lib/caddy/tali.network-ssl-bundle/private.key.pem {
        ca_root /var/lib/caddy/tali.network-ssl-bundle/intermediate.cert.pem
      }
    '';
  
    srvToDomain = srv: if srv ? stub
      then "${srv.stub}-home.tali.network"
      else "home.tali.network";
  
    srvToVirtHost = srv: {
      "${srvToDomain srv}".extraConfig = common + ''
        reverse_proxy :${builtins.toString srv.port}
      '' + (srv.extraSrvConfig or "");
    };

    webServices = config.srvProxy.services;
  in {
    # Set up caddy as a reverse proxy.
    services.caddy = {
      enable = true;
      virtualHosts = builtins.foldl'
        (acc: elem: (acc // (srvToVirtHost elem)))
        {} webServices;
    };
  
    # Enable dnsmasq... 
    services.dnsmasq = {
      enable = true;
      resolveLocalQueries = false;
      settings.server = [ "9.9.9.9" "149.112.112.112" "1.1.1.1" "8.8.8.8" ];
    };
  
    # ...And make sure domains point to the right server.
    networking.hosts = {
      "100.64.0.1" = builtins.map srvToDomain webServices;
    };
  };
}
