{ callPackage }:

{
  berkeley-mono = callPackage ./berkeley-fonts.nix {};
  init-el = callPackage ./init.el.d {};
}
