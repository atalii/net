{ pkgs, config, ... }:

{
  services.tailscale.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  environment.systemPackages = with pkgs; [
    neofetch # a necessity
    git nvi ghostty.terminfo
  ];

  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  users.users.atalii = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFYfx4uUXRxcWXGemF6zfwVIvqXOWKVchz78rWFJiwTk"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICUjegPPEjqyuN8pXNsu+rdSSVCtxOOEJEd6Abz8QMUp"
    ];
  };

  networking.firewall.allowedTCPPorts = [ 80 443 22 ];
}
