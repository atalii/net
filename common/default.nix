{ pkgs, config, ... }:

{
  services.tailscale.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  environment.systemPackages = with pkgs; [
    neofetch # a necessity
    git nvi
  ];

  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  users.users.atalii = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFYfx4uUXRxcWXGemF6zfwVIvqXOWKVchz78rWFJiwTk"
    ];
  };

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

  networking.firewall.allowedTCPPorts = [ 80 443 22 ];
}
