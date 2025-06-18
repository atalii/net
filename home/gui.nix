{ config, pkgs, ... }:

{
  home-manager.users.tali = {
    programs.ghostty = {
      enable = true;
      settings = {
        theme = "catppuccin-latte";
        font-family = "Berkeley Mono";
      };
    };

    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/default-applications/terminal" = {
          exec = "ghostty";
        };
      };
    };
  };

  users.users.tali.packages = with pkgs; [
    signal-desktop
    thunderbird
    anki
    gnucash
    chrysalis
    foliate

    wl-clipboard

    magic-wormhole

    haskell-language-server
    ghc
    cabal-install

    gopls
    go

    clang-tools

    svelte-language-server

    dfu-programmer
  ];

  fonts.packages = with pkgs; [ helvetica-neue-lt-std ];

  nixpkgs.config = {
    packageOverrides = pkgs: {
      magic-wormhole = pkgs.magic-wormhole.overridePythonAttrs {
        patches = [ ../patches/magic-wormhole/remove-that-one-warning.patch ];
      };
    };
  };
}
