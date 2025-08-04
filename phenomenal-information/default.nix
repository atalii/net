{ ... }: {
  imports = [
    ./hardware-configuration.nix
    
    ./networking.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "phenomenal-information";
  networking.domain = "";
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHlsdZRN8i12v5Uv2ZZtGqxqbf8T/n0H6U/UagIPUZy5 tali@thing-in-itself'' ];
  system.stateVersion = "23.11";
}
