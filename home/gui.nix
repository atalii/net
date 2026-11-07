{ config, pkgs, ... }:

{
  home-manager.users.tali = {

    home.packages = with pkgs; [
      gnomeExtensions.gsconnect
      yazi
      ibus
      zotero
    ];

    programs.ghostty = {
      enable = true;
      settings = {
        theme = "Catppuccin Latte";
        font-family = "Prestige Elite Std";

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
      export GTK_IM_MODULE="ibus"
    '';

    home.file.".XCompose".text = ''
      include "%L"

      <Multi_key> <a> <l> <l>: "∀"
      <Multi_key> <e> <x> <t>: "∃"

      <Multi_key> <a> <n> <d>: "∧"
      <Multi_key> <o> <r>: "∨"
      <Multi_key> <n> <o> <t>: "¬"
      <Multi_key> <:> <=>: "≔"

      <Multi_key> <i> <n>: "∈"
      <Multi_key> <n> <i> <n>: "∉"

      <Multi_key> <t> <o> <p>: "⊤"
      <Multi_key> <b> <o> <t>: "⊥"

      <Multi_key> <equal> <question>: "≟"

      <Multi_key> <l> <b>: "⟨"
      <Multi_key> <r> <b>: "⟩"

      <Multi_key> <C> <C>: "ℂ"
      <Multi_key> <F> <F>: "𝔽"
      <Multi_key> <H> <H>: "ℍ"
      <Multi_key> <K> <K>: "𝕂"
      <Multi_key> <N> <N>: "ℕ"
      <Multi_key> <Q> <Q>: "ℚ"
      <Multi_key> <R> <R>: "ℝ"
      <Multi_key> <Z> <Z>: "ℤ"

      <Multi_key> <g> <a>: "α"
      <Multi_key> <g> <A>: "Α"
      <Multi_key> <g> <b>: "β"
      <Multi_key> <g> <B>: "Β"
      <Multi_key> <g> <g>: "γ"
      <Multi_key> <g> <G>: "Γ"
      <Multi_key> <g> <d>: "δ"
      <Multi_key> <g> <D>: "Δ"
      <Multi_key> <g> <s>: "σ"
      <Multi_key> <g> <S>: "Σ"
      <Multi_key> <g> <l>: "λ"
      <Multi_key> <g> <L>: "Λ"

      <Multi_key> <g> <p> <h>: "φ"
      <Multi_key> <g> <p> <s>: "ψ"
    '';
  };

  users.users.tali.packages = with pkgs; [
    abcde

    signal-desktop
    thunderbird
    libreoffice
    gnucash
    foliate
    vlc
    gnome-boxes

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

    google-chrome

    zed-editor
    wireguard-tools
  ];

  fonts.packages = with pkgs; [ helvetica-neue-lt-std ];

  nixpkgs.config = {
    packageOverrides = pkgs: {
      magic-wormhole = pkgs.magic-wormhole.overridePythonAttrs {
        patches = [ ../patches/magic-wormhole/remove-that-one-warning.patch ];
      };
    };
  };

  programs.steam.enable = true;
}
