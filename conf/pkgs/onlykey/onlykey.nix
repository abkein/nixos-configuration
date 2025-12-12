{pkgs, lib, fetchFromGitHub, buildNpmPackage, nodejs, buildFHSEnv}:

let
  pname = "onlykey-app";
  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "abkein";
    repo = "OnlyKey-App";
    rev = "19ab6bb9c832139cb58638d1078c572025caa2af";
    hash = "sha256-VoSFYQXrsgy0N/7Fh0Z22BZE1iKPyT+jvTxLtLTR6nk=";
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
    # runScript = '' "$@"'';
  };

in buildNpmPackage {
  inherit pname version src;

  npmDepsHash = "sha256-UOj2Witdl1cZRobZVozXqaE9LTM6juD8q4ASO4vu+zc=";

  nativeBuildInputs = [ nodejs pkgs.nodePackages.gulp pkgs.nwjs ];

  npmFlags = [ "--ignore-scripts" ];

  buildPhase = ''
    gulp build
    # npx nw build/
    # ${lib.getExe pkgs.nwjs} build/
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/${pname}
    cp -r build/* $out/share/${pname}

    mkdir -p $out/bin
    cat > $out/bin/onlykey <<EOF
    #!${pkgs.runtimeShell}
    # exec ${fhsEnv}/bin/nwjs-env "$out/share/onlykey-app"
    exec ${lib.getExe pkgs.nwjs} "$out/share/onlykey-app"
    EOF
    chmod +x $out/bin/onlykey

    runHook postInstall
  '';

  meta = with lib; {
    description = "OnlyKey App built with vendored node dependencies";
    homepage = "https://github.com/trustcrypto/OnlyKey-App";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
