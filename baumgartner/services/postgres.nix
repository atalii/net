{ config, pkgs, ... }:

{
  services.postgresql = {
    enable = true;
    dataDir = "/data/postgres/15";

    enableTCPIP = true;
    authentication = ''
      local	all	all	trust
      host	all	all	100.64.0.0/10	scram-sha-256
    '';
  };
}
