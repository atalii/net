{ lib, ... }:
{
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [
      "8.8.8.8"
    ];
    enableIPv6 = true;
  };

  systemd.network.enable = true;
  systemd.network.networks."10-wan4" = {
    matchConfig.Name = "ens3";
    networkConfig.DHCP = "ipv4";
    networkConfig.IPv6AcceptRA = false;
    linkConfig.RequiredForOnline = "routable";
  };

  systemd.network.networks."10-wan6" = {
    matchConfig.Name = "ens5";
    networkConfig.DHCP = "no";
    networkConfig.IPv6AcceptRA = true;
    linkConfig.RequiredForOnline = "routable";
  };
}
