{
  lib,
  fetchurl,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "russia-v2ray-geoip";
  version = "202609010851";

  src = fetchurl {
    url = "https://github.com/runetfreedom/russia-v2ray-rules-dat/releases/download/${finalAttrs.version}/geoip.dat";
    hash = "sha256-0XUBfUma/a/2MQFcANL99RBRPlIoyrTEgGkwPxJFl8w=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/v2ray/
    install --mode=444 $src "$out/share/v2ray/geoip.dat"

    runHook postInstall
  '';

  meta = {
    description = "Russia specific GeoIP for V2Ray";
    homepage = "https://github.com/runetfreedom/russia-v2ray-rules-dat";
    license = lib.licenses.cc-by-sa-40;
    maintainers = with lib.maintainers; [ abkein ];
  };
})
