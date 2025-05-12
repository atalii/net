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
    signal-desktop thunderbird anki gnucash

    wl-clipboard

    magic-wormhole

    haskell-language-server ghc cabal-install

    gopls go

    clang-tools

    svelte-language-server
  ];

  fonts.packages = with pkgs; [ helvetica-neue-lt-std ];
}
