{ pkgs, lib, imhdss, ... }:

{
  systemd.services.imhdss = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    environment.PATH = lib.mkForce
      "/run/wrappers/bin:/run/current-system/sw/bin";

    serviceConfig = {
      ExecStart = "${imhdss.packages.x86_64-linux.default}/bin/imhdss";
    };
  };

  environment.etc."imhdss/conf.kdl".text = ''
    services {
      imhdss
      dnsmasq
      postgresql
      tailscaled
      wiki-js
      jellyfin
      invokeAI
    }

    links {
      "wiki.js" url="https://wiki-home.tali.network"
      jellyfin  url="https://jf-home.tali.network"
      invokeAI  url="https://nv-home.tali.network"
    }
  '';
}
