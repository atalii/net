{ config, pkgs, ... }:

{
  srvProxy.services = [
    # imhdss
    {
      port = 4525;
      extraSrvConfig = ''
        rewrite /favicon.ico /static/favicons/favicon.ico

        handle_path /static/* {
          root * /data/static
          file_server browse
        }
      '';
    }
  
    # Jellyfish
    { stub = "jf"; port = 8096; }
  
    # wiki-js
    { stub = "wiki";
      port = 3000;
      extraSrvConfig = ''
        rewrite /favicon.ico /static/favicons/favicon.ico
        
        handle_path /_assets/favicons/* {
          root * /data/static/favicons
          file_server
        }

        handle_path /static/* {
          root * /data/static
          file_server
        }
      '';
    }

    # invokeAI (stable diffusion)
    {
      stub = "in";
      port = 9090;
    }
  ];

  imports = [ ./jellyfin.nix ./postgres.nix ./wikijs.nix ./invokeai.nix ./imhdss.nix ];
}
