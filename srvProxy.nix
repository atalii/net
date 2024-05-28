{ config, pkgs, lib, ... }:

{
  options.srvProxy = {
    services = with lib; mkOption {
      description = "Descriptions of web services to proxy.";
      type = with types; listOf (attrsOf anything);
      default = [];
    };

    blocks = with lib; mkOption {
      description = "List of domain names to block via dnsmasq.";
      default = [];
    };
  };

  config = let
  
    common = ''
      tls /data/caddy/tali.network-ssl-bundle/domain.cert.pem /data/caddy/tali.network-ssl-bundle/private.key.pem {
        ca_root /data/caddy/tali.network-ssl-bundle/intermediate.cert.pem
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

    withWWW = host: [ "www.${host}" host ];

  in {
    # Set up caddy as a reverse proxy.
    services.caddy = {
      enable = true;
      virtualHosts = builtins.foldl'
        (acc: elem: (acc // (srvToVirtHost elem)))
        {} webServices;

      dataDir = "/data/caddy";
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
      "0.0.0.0" = lib.lists.concatMap withWWW config.srvProxy.blocks;
    };
  };
}
