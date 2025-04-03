{ ... }:

let
  baumgartner = "100.64.0.1";
  proxy = host: port: auth: (if auth then ''
    forward_auth localhost:9091 {
      uri /api/authz/forward-auth
      copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
    }
  '' else "") + ''
    reverse_proxy * "http://${host}:${toString port}"
  '';

  proxyBaum = proxy baumgartner;
in {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect
    
  ];

  services.caddy = {
    enable = true;
    virtualHosts."jellyfin.tali.network".extraConfig = proxyBaum 8096 false;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = false;
  swapDevices = [{ device = "/swap"; size = 2 * 1024; }];
  networking.hostName = "sensuous-manifold";
  networking.domain = "";
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHlsdZRN8i12v5Uv2ZZtGqxqbf8T/n0H6U/UagIPUZy5 tali@thing-in-itself'' ];
  system.stateVersion = "23.11";
}
