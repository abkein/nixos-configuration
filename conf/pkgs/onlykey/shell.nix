{ pkgs ? import <nixpkgs> { } }:
let
  fhs_env = pkgs.buildFHSEnv {
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
    runScript = "npx nw build/";
  };
in pkgs.mkShell {
  name = "onlykey-dev-shell";

  nativeBuildInputs = with pkgs; [ nodejs_20 git gcc python3 nwjs ];

  shellHook = ''
    export PATH="$PWD/node_modules/.bin:$PATH"

    alias run-nw='${fhs_env}/bin/nwjs-env'
  '';
}
