{ lib, pkgs, ... }:
let
  driveMount = "mnt-sms.mount";
  migraphx = pkgs.rocmPackages.migraphx.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./immich-migraphx-protobuf.patch ];
  });
  migraphxProvider =
    pkgs.runCommand "immich-migraphx-provider" { nativeBuildInputs = [ pkgs.patchelf ]; }
      ''
        mkdir -p $out/lib
        cp ${lib.getLib pkgs.onnxruntime}/lib/libonnxruntime_providers_migraphx.so $out/lib/
        chmod u+w $out/lib/libonnxruntime_providers_migraphx.so
        patchelf --replace-needed libmigraphx_c.so.3 ${migraphx}/lib/libmigraphx_c.so.3 \
          $out/lib/libonnxruntime_providers_migraphx.so
      '';
  immichPython = pkgs.python3.override (old: {
    packageOverrides = lib.composeExtensions (old.packageOverrides or (_: _: { })) (
      pyFinal: pyPrev: {
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
  });
in
{
  services.immich = {
    enable = true;
    package = pkgs.immich.overrideAttrs (old: {
      passthru = old.passthru // {
        machine-learning =
          (old.passthru.machine-learning.override { python3 = immichPython; }).overrideAttrs
            (oldMl: {
              patches = (oldMl.patches or [ ]) ++ [ ./immich-ocr-height.patch ];
              # Loading both libraries catches the protobuf collision without a GPU.
              postCheck = (oldMl.postCheck or "") + ''
                ${lib.getExe immichPython} - <<'PY'
                import ctypes
                from pathlib import Path
                import immich_ml.main
                import onnxruntime

                ctypes.CDLL(str(Path(onnxruntime.__file__).parent / "capi/libonnxruntime_providers_migraphx.so"))
                print("Immich/OpenCV/MIGraphX import regression check passed")
                PY
              '';
            });
      };
    });
    host = "0.0.0.0";
    openFirewall = true;
    mediaLocation = "/mnt/sms/immich/";
    accelerationDevices = null;
    environment = {
      CPU_CORES = "4";
    };
    machine-learning.environment = {
      # MIOpen does not use XDG_CACHE_HOME for its kernel cache or tuning database.
      MIOPEN_CUSTOM_CACHE_DIR = "/var/cache/immich/miopen/kernels";
      MIOPEN_USER_DB_PATH = "/var/cache/immich/miopen/db";
      # Gunicorn otherwise tries to create its control socket under /var/empty.
      XDG_RUNTIME_DIR = "/run/immich-machine-learning";

      MACHINE_LEARNING_REQUEST_THREADS = "4";
      MACHINE_LEARNING_WORKERS = "1";
      MACHINE_LEARNING_MAX_BATCH_SIZE__FACIAL_RECOGNITION = "1";
      MACHINE_LEARNING_MAX_BATCH_SIZE__OCR = "1";
    };
  };

  systemd.services = {
    immich-server = {
      wantedBy = lib.mkForce [ driveMount ];
      requires = [
        "redis-immich.service"
        "immich-machine-learning.service"
      ];
      bindsTo = [ driveMount ];
      after = [
        driveMount
        "redis-immich.service"
        "immich-machine-learning.service"
      ];
      unitConfig = {
        StartLimitIntervalSec = "600s";
        StartLimitBurst = 1;
      };
    };

    redis-immich = {
      wantedBy = lib.mkForce [ ];
      bindsTo = [ driveMount ];
      after = [ driveMount ];
      unitConfig.StopWhenUnneeded = true;
    };

    immich-machine-learning = {
      wantedBy = lib.mkForce [ ];
      bindsTo = [ driveMount ];
      after = [ driveMount ];
      unitConfig.StopWhenUnneeded = true;
      serviceConfig = {
        RuntimeDirectory = "immich-machine-learning";
        RuntimeDirectoryMode = "0700";
      };
    };
  };
}
