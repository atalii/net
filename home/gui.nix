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
  };

  users.users.tali.packages = with pkgs; [
    signal-desktop thunderbird

    wl-clipboard

    magic-wormhole

    haskell-language-server ghc cabal-install

    gopls go

    clang-tools

    svelte-language-server
  ];

  fonts.packages = with pkgs; [ helvetica-neue-lt-std ];
}
