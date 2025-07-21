{ stdenv, lib, fetchFromGitHub, nodejs, callPackage, buildFHSEnv
, pkgs ? import <nixpkgs> { } }:

let
  src = fetchFromGitHub {
    owner = "trustcrypto";
    repo = "OnlyKey-App";
    rev = "5401c2966638d04c19035fff85e95bfd3bce5511";
    hash = "sha256-8MSdr+ghCBPeGp63Yi1T+gyEwXOEUW3vqi9CrCmozrw=";
  };

  nodeEnv = callPackage ./default.nix { srcp=src; inherit pkgs; inherit nodejs; };

  fhsEnv = pkgs.buildFHSEnv {
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
        nodejs_20
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
    runScript = "nw build/";
  };

in stdenv.mkDerivation rec {
  pname = "onlykey-app";
  version = "5.5.0";
  inherit src;

  nativeBuildInputs = [ nodeEnv.nodeDependencies nodejs ];

  buildPhase = ''
    runHook preBuild
    ln -s ${nodeEnv.nodeDependencies}/lib/node_modules ./node_modules
    npm run build
    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/share/onlykey
    cp -r build/* $out/share/onlykey/
    mkdir -p $out/bin
    cat > $out/bin/onlykey <<EOF
    #!${stdenv.shell}
    exec ${fhsEnv}/bin/nwjs-env "\$@"
    EOF
    chmod +x $out/bin/onlykey
  '';

  meta = with lib; {
    description = "OnlyKey App built with vendored node dependencies";
    homepage = "https://github.com/trustcrypto/OnlyKey-App";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
