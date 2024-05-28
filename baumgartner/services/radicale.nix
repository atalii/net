{ config, pkgs, ... }:

{
  srvProxy.services = [{ stub = "rd"; port = 8192; }];

  services.radicale = {
    enable = true;

    settings = {
      server.hosts = [ "localhost:8192" ];
      storage.filesystem_folder = "/data/radicale/store";
      auth = {
        type = "htpasswd";
        htpasswd_filename = "/data/radicale/users";
        htpasswd_encryption = "bcrypt";
      };
    };
  };
}
