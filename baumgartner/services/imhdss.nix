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
}
