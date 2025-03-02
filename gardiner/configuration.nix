{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect

  ];

  services.tailscale.useRoutingFeatures = "server";

  services.gotosocial = {
    enable = true;
    settings = {
      protocol = "https";
      host = "fedi.tali.network";
      accounts-allow-custom-css = true;
    };
  };

  services.caddy = {
    enable = true;
    virtualHosts."fedi.tali.network".extraConfig = ''
      reverse_proxy * http://127.0.0.1:8080 {
          flush_interval -1
      }
    '';

    virtualHosts."tali.network".extraConfig = ''
      respond "Nothing here yet!"
    '';

    virtualHosts."files.tali.network".extraConfig = ''
      root * /data/public
      file_server
    '';

    virtualHosts."jellyfin.tali.network".extraConfig = ''
      reverse_proxy * https://jf-home.tali.network {
        header_up Host "jf-home.tali.network"
      }
    '';

    virtualHosts."code.tali.network".extraConfig = ''
      reverse_proxy * https://code-home.tali.network {
        header_up Host "code-home.tali.network"
      }
    '';
  };

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "gardiner";
  networking.domain = "";
  services.openssh.enable = true;
  system.stateVersion = "23.11";
}
