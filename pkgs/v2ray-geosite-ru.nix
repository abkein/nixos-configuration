{
  lib,
  fetchurl,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "russia-v2ray-geosite";
  version = "202605040625";

  src = fetchurl {
    url = "https://github.com/runetfreedom/russia-v2ray-rules-dat/releases/download/${finalAttrs.version}/geosite.dat";
    hash = "sha256-mZy0KINBDkCAv1w1749xA6cc+dmHBx/ETuS0rYQ6UX8=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/v2ray/
    install --mode=444 $src "$out/share/v2ray/geosite.dat"

    runHook postInstall
  '';

  meta = {
    description = "Russia specific GeoSite data for V2Ray";
    homepage = "https://github.com/runetfreedom/russia-v2ray-rules-dat";
    license = lib.licenses.cc-by-sa-40;
    maintainers = with lib.maintainers; [ abkein ];
  };
})
