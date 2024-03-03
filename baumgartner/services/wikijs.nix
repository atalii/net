{ config, pkgs, ... }:

{
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
