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

    # miniflux
    {
      stub = "rss";
      port = 1819;
    }

    # distcc
    {
      stub = "cc";
      port = 3633;
    }

    # paperless
    {
      stub = "pl";
      port = 28981;

      extraSrvConfig = ''
        rewrite /favicon.ico /talicorp-static/art/favicons/tc-logo-pink.ico

        handle_path /talicorp-static/* {
          root * /data/static
          file_server
        }
      '';
    }
  ];

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
