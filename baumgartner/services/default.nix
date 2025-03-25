{ config, pkgs, ... }:

{
  imports = [
    ./jellyfin.nix ./postgres.nix ./wikijs.nix ./imhdss.nix ./radicale.nix ./paperless.nix ./miniflux.nix
  ];

  services.code-server.enable = true;
  services.code-server.auth = "none";
  services.code-server.host = "0.0.0.0";

  services.code-server.package = pkgs.vscode-with-extensions.override {
    vscode = pkgs.code-server;
    vscodeExtensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      myriad-dreamin.tinymist
      jnoortheen.nix-ide
      haskell.haskell justusadam.language-haskell
      llvm-vs-code-extensions.vscode-clangd
      ms-python.python ms-pyright.pyright
    ];
  };

  networking.firewall.allowedTCPPorts = [ 4444 ];

  services.distccd.enable = true;
  services.distccd.allowedClients = [ "127.0.0.1" "100.64.0.0/10" "192.168.0.0/16" ];
  services.distccd.openFirewall = true;
  services.distccd.stats.enable = true;
  services.distccd.logLevel = "info";

  users.users.code-server.packages = with pkgs; [
    gcc clang
    tinymist typst
    nixd
    clang-tools
    haskell-language-server cabal-install ghc
    bash
    python3 pyright poetry black
  ];
}
