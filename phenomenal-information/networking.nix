{ lib, ... }:
{
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [
      "8.8.8.8"
    ];
    defaultGateway = "162.221.207.1";
    defaultGateway6 = {
      address = "fe80:2605:80:8::1";
      interface = "eth0";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          {
            address = "162.221.207.136";
            prefixLength = 24;
          }
        ];
        ipv6.addresses = [
          {
            address = "fe80::6ec3:7fff:fe04:e58f";
            prefixLength = 64;
          }
        ];
        ipv4.routes = [
          {
            address = "162.221.207.1";
            prefixLength = 32;
          }
        ];
        ipv6.routes = [
          {
            address = "fe80:2605:80:8::1";
            prefixLength = 128;
          }
        ];
      };

    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="14:d4:19:99:fa:b9", NAME="eth0"
  '';
}
