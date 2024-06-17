{ pkgs ? import <nixpkgs> }:

pkgs.stdenvNoCC.mkDerivation rec {
  pname = "berkely-mono";
  version = "1.009";

  src = pkgs.fetchurl {
    url = "https://home.tali.network/static/berkeley-mono-typeface.zip";
    hash = "sha256-BmDOa9cy8o2fooLpQ6PnZRZYL440cKR1LXQvwabCeN8=";
  };

  nativeBuildInputs = with pkgs; [ unzip ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    runHook preInstall

    install -Dm444 berkeley-mono/TTF/*.ttf -t $out/share/fonts/truetype/${pname}
    install -Dm444 berkeley-mono-variable/TTF/*.ttf -t $out/share/fonts/truetype/${pname}

    runHook postInstall
  '';
}
