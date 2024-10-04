{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect

  ];


  services.gotosocial = {
    enable = true;
    settings = {
      protocol = "http";
      host = "fedi.tali.network";
    };
  };

  services.caddy = {
    enable = true;
    virtualHosts."fedi.tali.network".extraConfig = ''
      reverse_proxy localhost:8080
    '';
  };

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "gardiner";
  networking.domain = "";
  services.openssh.enable = true;
  system.stateVersion = "23.11";
}
