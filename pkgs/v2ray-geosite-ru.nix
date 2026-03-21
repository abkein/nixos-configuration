{
  lib,
  fetchurl,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "russia-v2ray-geosite";
  version = "202603181028";

  src = fetchurl {
    url = "https://github.com/runetfreedom/russia-v2ray-rules-dat/releases/download/${finalAttrs.version}/geosite.dat";
    hash = "sha256-lJAw2SdINlIfY5rDgPannzqYme+hbwvMDwpl8AFKDE4=";
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
