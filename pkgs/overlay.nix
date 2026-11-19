final: prev:
let
  #   solo1-cli = prev.fetchFromGitHub {
  #     owner = "abkein";
  #     repo = "solo1-cli";
  #     rev = "ea8dc795729356eb421db5918b4392316ab90f77";
  #     hash = "sha256-nJ+2NWpRGyVz2mRNohOBR9DHYoTFjtD+rTTrr2WsY0w=";
  #   };
  lib = final.lib;
in
{
  python3Packages = prev.python3Packages.overrideScope (
    pyFinal: pyPrev:
    let
      migraphxProvider =
        final.runCommand "migraphx-provider" { nativeBuildInputs = [ final.patchelf ]; }
          ''
            mkdir -p $out/lib
            cp ${lib.getLib final.onnxruntime}/lib/libonnxruntime_providers_migraphx.so $out/lib/
            chmod u+w $out/lib/libonnxruntime_providers_migraphx.so
            patchelf --replace-needed libmigraphx_c.so.3 ${final.rocmPackages.migraphx}/lib/libmigraphx_c.so.3 \
              $out/lib/libonnxruntime_providers_migraphx.so
          '';
    in
    {
      # solo1-cli = pySelf.callPackage "${solo1-cli}/solo.nix" { };

      keepassxc-proxy-client = pyFinal.callPackage ./keepassxc-proxy-client.nix { };
      jsonc-parser = pyFinal.callPackage ./jsonc-parser.nix { };
      crossrefapi = pyFinal.callPackage ./crossrefapi.nix { };
      lammps-logfile = pyFinal.callPackage ./lammps-logfile.nix { };
      pyalex = pyFinal.callPackage ./pyalex.nix { };

      # pyemf3 = pySelf.callPackage ./pyemf3.nix { };

      onnxruntime = pyPrev.onnxruntime.overrideAttrs (oldOrt: {
        # The Python wheel omits MIGraphX's provider. Both Immich and ONNX
        # Runtime load it from capi/, so reuse the matching native library.
        postInstall = (oldOrt.postInstall or "") + ''
          ln -s ${migraphxProvider}/lib/libonnxruntime_providers_migraphx.so \
            $out/${pyFinal.python.sitePackages}/onnxruntime/capi/libonnxruntime_providers_migraphx.so
        '';
      });
    }
  );

  # solo1-cli = final.python3Packages.solo1-cli;

  keepassxc-proxy-client = final.python3Packages.keepassxc-proxy-client;
  jsonc-parser = final.python3Packages.jsonc-parser;
  crossrefapi = final.python3Packages.crossrefapi;
  lammps-logfile = final.python3Packages.lammps-logfile;
  pyalex = final.python3Packages.pyalex;

  # pyemf3 = final.python3Packages.pyemf3;
  # veusz = prev.callPackage ./veusz { };

  # kdePackages = prev.kdePackages.overrideScope (kfinal: kprev: {
  #   dolphin = prev.symlinkJoin {
  #     name = "dolphin-wrapped";
  #     paths = [ kprev.dolphin kprev.dolphin.dev ];
  #     nativeBuildInputs = [ prev.makeWrapper ];
  #     postBuild = ''
  #       rm $out/bin/dolphin
  #       makeWrapper ${kprev.dolphin}/bin/dolphin $out/bin/dolphin \
  #         --set XDG_CONFIG_DIRS "${kprev.kservice}/etc/xdg:$XDG_CONFIG_DIRS" \
  #         --run "${kprev.kservice}/bin/kbuildsycoca6 --noincremental ${kprev.kservice}/etc/xdg/menus/applications.menu"
  #     '';
  #     passthru = (kprev.dolphin.passthru or {}) // { dev = kprev.dolphin.dev; };
  #   };
  # });

  # ibus-engines = prev.ibus-engines // {
  #   typing-booster-unwrapped = final.callPackage ./ibus-typing-booster { };
  # };

  rocmPackages = prev.rocmPackages.overrideScope (
    _rocmFinal: rocmPrev: {
      clr = rocmPrev.clr.override { localGpuTargets = [ "gfx1103" ]; };
      # Composable Kernel builds without a gfx9 target are marked broken.
      miopen = rocmPrev.miopen.override { withComposableKernel = false; };
      migraphx = rocmPrev.migraphx.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ./migraphx/migraphx-protobuf.patch ];
      });
      aotriton = rocmPrev.aotriton.overrideAttrs (old: {
        # Backport the Triton 3.9 compatibility fix until nixpkgs includes PR #589629.
        patches = (old.patches or [ ]) ++ [ ./aotriton/triton-3.9-composed-tensors.patch ];
        # Preserve Triton 3.9's default and avoid a warning for every kernel.
        env = (old.env or { }) // {
          TRITON_DEFAULT_FP_FUSION = "1";
        };
        # AOTriton 0.12b supports gfx1103, but the pinned nixpkgs gpuTargets
        # filter omits it. Setting gpuTargets alone would select shim-only
        # mode, so set the CMake target while retaining kernel image builds.
        cmakeFlags =
          builtins.filter (flag: !(lib.hasPrefix "-DAOTRITON_TARGET_ARCH:" flag)) old.cmakeFlags
          ++ [ (lib.cmakeFeature "AOTRITON_TARGET_ARCH" "gfx1103") ];
      });
    }
  );

  vscode-extensions = prev.vscode-extensions // {
    vscode-clang-tidy = import ./vscode-clang-tidy/vscode-clang-tidy.nix final;
    ms-vscode.cpptools = prev.vscode-extensions.ms-vscode.cpptools.overrideAttrs (old: {
      postPatch = (old.postPatch or "") + ''
        chmod +x bin/cpptools-srv2
      '';
    });
  };
  zotero-addons = final.callPackage ./zotero-addons.nix { };
  micro-plugins = final.callPackage ./micro-plugins.nix { };
  vimix-icon-theme = final.callPackage ./vimix-icon-theme.nix { };

  v2ray-geoip-ru = final.callPackage ./v2ray-geoip-ru.nix { };
  v2ray-geosite-ru = final.callPackage ./v2ray-geosite-ru.nix { };
  xray = prev.xray.override {
    assets = with final; [
      v2ray-geoip-ru
      v2ray-geosite-ru
    ];
  };

  # waybar = prev.waybar.overrideAttrs (old: {
  #   src = final.fetchFromGitHub {
  #     owner = "Alexays";
  #     repo = "Waybar";
  #     rev = "c15ec02ede4343592a59eb5c2ff4443c9c045f7c";
  #     hash = "sha256-mBDWjeeIuFfDZQuBxHu+EpbJ+GMbbSxpRz0WVM2N+ZI=";
  #   };

  #   postUnpack = ''
  #     pushd "$sourceRoot"
  #     cp -R --no-preserve=mode,ownership ${final.libcava.src} subprojects/cava-${final.libcava.version}
  #     patchShebangs .
  #     popd
  #   '';

  #   buildInputs =
  #     old.buildInputs
  #     ++ (with final; [
  #       modemmanager
  #       libepoxy
  #     ]);
  # });
}
