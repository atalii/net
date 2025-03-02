{ config, pkgs, ... }:

{
  srvProxy.services = [ { stub = "cc"; port = 3633; } ];
  srvProxy.blocks = [ "youtube.com" "m.youtube.com" "reddit.com" "googlevideo.com" "l.opnxng.com" "invidio.us" "invidious.incogniweb.com" ];

  imports = [
    ./jellyfin.nix ./postgres.nix ./wikijs.nix ./imhdss.nix ./radicale.nix ./paperless.nix ./miniflux.nix
  ];

  services.code-server.enable = true;
  services.code-server.hashedPassword = "$argon2i$v=19$m=4096,t=3,p=1$/g/q/I1Jc3+qERsL0Mcljg$BdEN30C3aOmP2NaLZklTC2aAQrS7jkivj/PPW9ZNx2Q";
  services.code-server.host = "0.0.0.0";

  services.code-server.package = pkgs.vscode-with-extensions.override {
    vscode = pkgs.code-server;
    vscodeExtensions = with pkgs.vscode-extensions; [
      vscodevim.vim myriad-dreamin.tinymist jnoortheen.nix-ide
    ];
  };

  networking.firewall.allowedTCPPorts = [ 4444 ];

  services.distccd.enable = true;
  services.distccd.allowedClients = [ "127.0.0.1" "100.64.0.0/10" "192.168.0.0/16" ];
  services.distccd.openFirewall = true;
  services.distccd.stats.enable = true;
  services.distccd.logLevel = "info";

  users.users.code-server.packages = with pkgs; [ gcc clang tinymist typst nixd ];
}
