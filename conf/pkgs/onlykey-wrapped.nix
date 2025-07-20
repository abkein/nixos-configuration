{ lib, node_webkit, pkgs, copyDesktopItems, makeDesktopItem, stdenv
, writeShellScript, wrapGAppsHook3, }:

let
  # parse the version from package.json
  version = let
    packageJson = lib.importJSON ./package.json;
    splits = builtins.split "^.*#v(.*)$"
      (builtins.getAttr "onlykey" (builtins.head packageJson));
    matches = builtins.elemAt splits 1;
    elem = builtins.head matches;
  in elem;

  # upstream git source
  onlykeyPkg =
    "onlykey-git+https://github.com/trustcrypto/OnlyKey-App.git#v${version}";
  onlykey = self."${onlykeyPkg}";
  super = import ./onlykey.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
  };
  self = super // {
    "${onlykeyPkg}" = super."${onlykeyPkg}".override (attrs: {
      npmFlags = (attrs.npmFlags or "") + " --ignore-scripts";
      postInstall = ''
        cd $out/lib/node_modules/${attrs.packageName}
        npm run build
      '';
    });
  };

  # launcher script with optional flags
  script =
    writeShellScript "${onlykey.packageName}-starter-${onlykey.version}" ''
      # disable GPU & sandbox if needed, adjust flags here
      export NODE_EXTRA_CA_CERTS=${pkgs.nss_cacert}/etc/ssl/certs/ca-bundle.crt
      exec ${node_webkit}/bin/nw \
           --disable-gpu --disable-gpu-sandbox --no-sandbox \
           ${onlykey}/lib/node_modules/${onlykey.packageName}/build
    '';

in stdenv.mkDerivation {
  pname = onlykey.packageName;
  inherit (onlykey) version;

  dontUnpack = true;

  # GSettings hook already included, add runtime deps
  nativeBuildInputs = [ wrapGAppsHook3 copyDesktopItems ];
  buildInputs = [ pkgs.dbus pkgs.glib pkgs.libsecret pkgs.nss_cacert ];

  dontPatchELF = true;

  desktopItems = [
    (makeDesktopItem {
      name = onlykey.packageName;
      exec = script;
      icon =
        "${onlykey}/lib/node_modules/${onlykey.packageName}/resources/onlykey_logo_128.png";
      desktopName = onlykey.packageName;
      genericName = onlykey.packageName;
    })
  ];

  installPhase = ''
    runHook preInstall

    # compile GSettings schemas
    mkdir -p $out/share/glib-2.0/schemas
    cp -r ${pkgs.gsettings-desktop-schemas}/share/glib-2.0/schemas/* $out/share/glib-2.0/schemas/
    glib-compile-schemas $out/share/glib-2.0/schemas

    # install launcher
    mkdir -p $out/bin
    ln -s ${script} $out/bin/onlykey

    runHook postInstall
  '';
}
