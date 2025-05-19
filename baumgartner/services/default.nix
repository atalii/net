{ pkgs, ... }:

{
  imports = [
    ./jellyfin.nix ./postgres.nix ./wikijs.nix ./radicale.nix ./miniflux.nix
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

      (pkgs.vscode-utils.buildVscodeMarketplaceExtension rec {
        mktplcRef = {
          name = "lean4";
          version = "0.0.183";
          publisher = "leanprover";
        };
        vsix = builtins.fetchurl {
          name = "${mktplcRef.publisher}-${mktplcRef.name}.zip";
          url = "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/leanprover/vsextensions/lean4/0.0.183/vspackage";
          sha256 = "07mmjp7fh0v4dwqhb62v8khg5jns7ax79z5pdqw04aw16zv46jd8";
        };
      })
    ];
  };

  networking.firewall.allowedTCPPorts = [ 4444 ];

  services.distccd.enable = true;
  services.distccd.allowedClients = [ "127.0.0.1" "100.64.0.0/10" "192.168.0.0/16" ];
  services.distccd.openFirewall = true;
  services.distccd.stats.enable = true;
  services.distccd.logLevel = "info";

  services.prometheus = {
    enable = true;

    exporters.node = {
      enable = true;
      enabledCollectors = [ "logind" "systemd" ];
    };

    scrapeConfigs = [
      {
        job_name = "node:baumgartner";
        static_configs = [{
          targets = [ "localhost:9100" ];
        }];
      }
      {
        job_name = "node:sensuous-manifold";
        static_configs = [{
          targets = [ "sm.tali.network" ];
        }];
      }
      {
        job_name = "caddy:sensuous-manifold";
        static_configs = [{
          targets = [ "100.69.247.123:2019" ];
        }];
      }
    ];
  };

  services.grafana = {
    enable = true;
    settings = {
      server = {
        domain = "grafana.tali.network";

        # 3000 is the default, but WikiJS is using that.
        http_port = 4000;
        http_addr = "0.0.0.0";
      };

      auth = {
	disable_login_form = true;
      };

      "auth.anonymous" = {
        enabled = true;
        org_role = "Admin";
      };
    };
  };

  users.users.code-server.packages = with pkgs; [
    gcc clang
    tinymist typst
    elan nixd
    clang-tools
    haskell-language-server cabal-install ghc
    bash
    python3 pyright poetry black
  ];
}
