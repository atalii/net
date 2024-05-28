{ config, pkgs, ... }:

{
  srvProxy.services = [{
    stub = "wiki";
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
  }];

  services.wiki-js = {
    enable = true;
    environmentFile = "/data/secrets/wiki-js.env";

    settings = {
      db = {
        type = "postgres";
        host = "localhost";
        port = 5432;
        db = "wikijs";
        user = "wikijs";
        pass = "$(WIKI_PG_PASS)";
      };

      bindIp = "127.0.0.1";
    };
  };
}
