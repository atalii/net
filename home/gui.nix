{ config, pkgs, ... }:

{
  home-manager.users.tali = {

    home.packages = with pkgs; [
      gnomeExtensions.gsconnect
      yazi
    ];

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

    programs.atuin.enable = true;

    xsession.profileExtra = ''
      # The default Gnome compose key picker uses a hard-coded list of
      # sequences. Don't use it.
      export GTK_IM_MODULE="xim"
    '';

    home.file.".XCompose".text = ''
      include "%L"

      <Multi_key> <a> <n> <d>: "∧"
      <Multi_key> <o> <r>: "∨"
      <Multi_key> <n> <o> <t>: "¬"

      <Multi_key> <i> <n>: "∈"
      <Multi_key> <n> <i> <n>: "∉"

      <Multi_key> <C> <C>: "ℂ"
      <Multi_key> <N> <N>: "ℕ"
      <Multi_key> <R> <R>: "ℝ"
      <Multi_key> <Q> <Q>: "ℚ"

      <Multi_key> <a> <a>: "α"
      <Multi_key> <a> <A>: "Α"
      <Multi_key> <b> <b>: "β"
      <Multi_key> <b> <B>: "Β"
      <Multi_key> <g> <G>: "Γ"
      <Multi_key> <g> <g>: "γ"
      <Multi_key> <d> <d>: "δ"
      <Multi_key> <d> <D>: "Δ"
    '';
  };

  users.users.tali.packages = with pkgs; [
    signal-desktop
    thunderbird
    libreoffice
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

    yaml-language-server

    verible
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
