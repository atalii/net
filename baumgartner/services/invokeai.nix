{ pkgs, config, nixified-ai, ... }:

{
  systemd.services.invokeAI = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    environment.INVOKEAI_ROOT = "/data/invokeai";

    serviceConfig = {
      ExecStart = "${nixified-ai.packages.x86_64-linux.invokeai-amd}/bin/invokeai-web";
    };
  };
}
