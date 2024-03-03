{ config, pkgs, ... }:

{
  srvProxy.services = [
    # Status
    { port = 4525; }
  
    # Jellyfish
    { stub = "jf"; port = 8096; }
  
    # wiki-js
    { stub = "wiki";
      port = 3000;
      extraSrvConfig = ''
        handle_path /static/* {
          root * /data/static
          file_server
        }
      '';
    }
  ];

  imports = [ ./jellyfin.nix ./postgres.nix ./wikijs.nix ];
}
