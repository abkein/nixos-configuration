{ lib, ... }:
{
  nixpkgs.overlays = [
    (_final: prev: {
      rocmPackages = prev.rocmPackages.overrideScope (
        _rocmFinal: rocmPrev: {
          aotriton = rocmPrev.aotriton.overrideAttrs (old: {
            # AOTriton 0.12b supports gfx1103, but the pinned nixpkgs gpuTargets
            # filter omits it. Setting gpuTargets alone would select shim-only
            # mode, so set the CMake target while retaining kernel image builds.
            cmakeFlags =
              builtins.filter (flag: !(lib.hasPrefix "-DAOTRITON_TARGET_ARCH:" flag)) old.cmakeFlags
              ++ [ (lib.cmakeFeature "AOTRITON_TARGET_ARCH" "gfx1103") ];
          });
        }
      );
    })
  ];
}
