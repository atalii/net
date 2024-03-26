{ config, pkgs, ... }:

{
  srvProxy.services = [
    # imhdss
    {
      port = 4525;
      extraSrvConfig = ''
        rewrite /favicon.ico /static/art/favicons/tc-logo-red.ico

        handle_path /static/* {
          root * /data/static
          file_server browse
        }
      '';
    }

    # radicale
    { stub = "rd"; port = 8192; }
  
    # Jellyfish
    { stub = "jf"; port = 8096; }
  
    # wiki-js
    { stub = "wiki";
      port = 3000;
      extraSrvConfig = ''
        rewrite /favicon.ico /static/art/favicons/tc-logo-green.ico
        rewrite /_assets/favicons/android-chrome-192x192.png /static/art/favicons/tc-logo-green-192x192.png
        rewrite /_assets/favicons/favicon-16x16.png /static/art/favicons/tc-logo-green-48x48.png

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

  imports = [
    ./jellyfin.nix ./postgres.nix ./wikijs.nix ./invokeai.nix ./imhdss.nix ./radicale.nix
  ];
}
