{ stdenvNoCC, fetchurl, unzip }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "berkely-mono";
  version = "1.009";

  src = fetchurl {
    url = "https://home.tali.network/static/berkeley-mono-typeface.zip";
    hash = "sha256-BmDOa9cy8o2fooLpQ6PnZRZYL440cKR1LXQvwabCeN8=";
  };

  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    runHook preInstall

    install -Dm444 berkeley-mono/TTF/*.ttf -t $out/share/fonts/truetype/${finalAttrs.pname}
    install -Dm444 berkeley-mono-variable/TTF/*.ttf -t $out/share/fonts/truetype/${finalAttrs.pname}

    runHook postInstall
  '';
})
