{
  lib,
  fetchFromGitHub,
  buildGo126Module,
  makeWrapper,
  nix-update-script,
  environment ? null,
}:
let
  mkSetDef = variable: value: "--set-default ${variable} ${value}";
in
buildGo126Module (finalAttrs: {
  pname = "xray";
  version = "26.3.27";

  src = fetchFromGitHub {
    owner = "XTLS";
    repo = "Xray-core";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tSSoaIKHgLf9ry6p0Y+BM1Nx8X+40BDDfJJYkABUoEc=";
  };

  vendorHash = "sha256-kwvck6Eo/e6qgb1ENznhwZ/GPX75ssLUvR2u8Qm3UIM=";

  nativeBuildInputs = [ makeWrapper ];

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
  ];
  subPackages = [ "main" ];

  installPhase = ''
    runHook preInstall
    install -Dm555 "$GOPATH"/bin/main $out/bin/xray
    runHook postInstall
  '';

  postFixup = lib.optionalString (environment != null) (
    lib.concatStringsSep " " (
      [
        "wrapProgram"
        "$out/bin/xray"
      ]
      ++ (lib.mapAttrsToList mkSetDef environment)
    )
  );

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Platform for building proxies to bypass network restrictions. A replacement for v2ray-core, with XTLS support and fully compatible configuration";
    mainProgram = "xray";
    homepage = "https://github.com/XTLS/Xray-core";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ iopq ];
  };
})
