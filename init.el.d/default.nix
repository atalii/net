{ pkgs ? import <nixpkgs> { } }:

let
  packages = pkgs.callPackage ./pkgs.nix {};

  pkgToPreamble = pkg: ''
    ;; Auto-generated peramble for: ${pkg.name}
    (add-to-list 'load-path "${pkg.dir}")
    (require '${pkg.name})
  '';

  pkgToConf = pkg: ''
    ;; Auto-generated conf section for: ${pkg.name}
    ${pkg.config or ";; EMPTY"}
  '';

  pkgToPostamble = pkg: ''
    ;; Auto-generated postamble for: ${pkg.name}
    ${pkg.postamble or ";; EMPTY"}
  '';

  forPackages = f: pkgs.lib.concatStringsSep "\n"
    (map f packages);

  preamble = forPackages pkgToPreamble;
  config = forPackages pkgToConf;
  postamble = forPackages pkgToPostamble;

  extraConfig = builtins.readFile ./extra-config.el;

  initContents = pkgs.lib.concatStringsSep "\n"
    [ preamble config postamble extraConfig ];

in pkgs.writeText "init.el" initContents
