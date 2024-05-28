{ pkgs, ... }:
{
  srvProxy.services = [{
    stub = "pl";
    port = 28981;

    extraSrvConfig = ''
      rewrite /favicon.ico /talicorp-static/art/favicons/tc-logo-pink.ico

      handle_path /talicorp-static/* {
        root * /data/static
        file_server
      }
    '';
  }];

  services.paperless.enable = true;
  services.paperless.dataDir = "/data/paperless";
}
