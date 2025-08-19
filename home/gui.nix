{ config, pkgs, ... }:

{
  home-manager.users.tali = {

    home.packages = with pkgs; [ gnomeExtensions.gsconnect ];

    programs.ghostty = {
      enable = true;
      settings = {
        theme = "catppuccin-latte";
        font-family = "Berkeley Mono";

        keybind = [
          "ctrl+shift+h=goto_split:left"
          "ctrl+shift+l=goto_split:right"
          "ctrl+shift+space=new_split:right"
        ];
      };
    };

    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/default-applications/terminal" = {
          exec = "ghostty";
        };
        "org/gnome/shell".enabled-extensions = [
          "gsconnect@andyholmes.github.io"
        ];
      };
    };

    xsession.profileExtra = ''
      # The default Gnome compose key picker uses a hard-coded list of
      # sequences. Don't use it.
      export GTK_IM_MODULE="xim"
    '';

    home.file.".XCompose".text = ''
      include "%L"

      <Multi_key> <a> <n> <d>: "∧"
      <Multi_key> <o> <r>: "∨"
    '';
  };

  users.users.tali.packages = with pkgs; [
    signal-desktop
    thunderbird
    anki
    gnucash
    foliate
    vlc

    wl-clipboard

    magic-wormhole

    haskell-language-server
    ghc
    cabal-install

    ocaml
    ocamlPackages.ocaml-lsp
    ocamlPackages.ocamlformat
    dune_3

    rust-analyzer

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
