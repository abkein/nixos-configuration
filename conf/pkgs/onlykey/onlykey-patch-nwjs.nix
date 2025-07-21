{ lib, fetchFromGitHub, buildNpmPackage, nodejs, jq, buildFHSEnv
, pkgs ? import <nixpkgs> { } }:

let
  pname = "onlykey-app";
  version = "5.5.0";

  upstreamSrc = fetchFromGitHub {
    owner = "abkein";
    repo = "OnlyKey-App";
    rev = "19ab6bb9c832139cb58638d1078c572025caa2af";
    hash = "sha256-VoSFYQXrsgy0N/7Fh0Z22BZE1iKPyT+jvTxLtLTR6nk=";
  };

  patchedSrc = pkgs.stdenv.mkDerivation {
    name = "patched-onlykey-src";
    src = upstreamSrc;
    nativeBuildInputs = [ jq nodejs ];

    phases = [ "unpackPhase" "patchPhase" "installPhase" ];

    patchPhase = ''
            echo "Injecting dummy nw package"
            jq '.dependencies.nw = "file:nw-dummy"' package.json > package.json.new
            mv package.json.new package.json

            mkdir -p nw-dummy
            cat > nw-dummy/package.json <<EOF
            {
              "name": "nw",
              "version": "0.0.1",
              "main": "index.js"
            }
      EOF
            echo "module.exports = {};" > nw-dummy/index.js

            echo "Generating package-lock.json"
            npm install --package-lock-only
    '';

    installPhase = ''
      mkdir -p $out
      cp -r . $out/
    '';
  };

  fhsEnv = buildFHSEnv {
    name = "nwjs-env";
    targetPkgs = pkgs:
      with pkgs; [
        glib
        gdk-pixbuf
        nspr
        at-spi2-atk
        libdrm
        dbus
        libgbm
        expat
        xorg.libxcb
        pango
        cairo
        systemd
        vulkan-loader
        vulkan-headers
        libglvnd
        nodejs_22
        nwjs
        libGL
        mesa
        alsa-lib
        gtk3
        nss
        cups
        libxkbcommon
        xorg.libX11
        xorg.libXcomposite
        xorg.libXdamage
        xorg.libXext
        xorg.libXfixes
        xorg.libXrandr
        xorg.libXScrnSaver
        xorg.libXtst
      ];
    runScript = ''nw "$@"'';
  };

in buildNpmPackage {
  inherit pname version;
  src = patchedSrc;

  npmDepsHash = "sha256-R5g4hO1s4K6EAfYpebxlYz4nogBk4TY4dNT2jZpEF8w=";

  nativeBuildInputs = [ nodejs pkgs.nodePackages.gulp ];

  buildPhase = ''
    gulp build
  '';

  installPhase = ''
    mkdir -p $out/onlykey-app
    mkdir -p $out/node_modules/.bin/nw
    ln -s ${pkgs.nwjs}/bin/nw $out/node_modules/.bin/nw
    cp -r build/* $out/onlykey-app

    mkdir -p $out/bin
    cat > $out/bin/onlykey <<EOF
    #!${pkgs.runtimeShell}
    exec ${fhsEnv}/bin/nwjs-env "$out/onlykey-app"
    EOF
    chmod +x $out/bin/onlykey
  '';

  meta = with lib; {
    description = "OnlyKey App built with vendored node dependencies";
    homepage = "https://github.com/trustcrypto/OnlyKey-App";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}

