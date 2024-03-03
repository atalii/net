{ config, pkgs, ... }:

{
  services.postgresql = {
    enable = true;

    dataDir = "/data/postgres/15";

    authentication = ''
      local	all	all	trust
    '';
  };
}
