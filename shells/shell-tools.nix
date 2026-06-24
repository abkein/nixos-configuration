{
  nixpkgs,
  system,
  lib ? nixpkgs.lib,
  mylib,
}:
let
  _mkShell =
    layers:
    let
      ctx = mylib.lazyMergeListDeep layers;
      shellHook = lib.concatStringsSep "\n" ctx.shellHook;
    in
    ctx.shellPkgs.mkShell (ctx.shellArgs // { inherit shellHook; });

  _mkBuilder = layers: {
    __functor = self: layer: self.instantiate layer;

    instantiate = layer: lib.makeOverridable _mkShell (layers ++ [ layer ]);

    extend = layer: _mkBuilder (layers ++ [ layer ]);
    addModules = layers': _mkBuilder (layers ++ layers'); # same as `extend`, but accepting several layers
  };

  seedLayer = (
    final: {
      nixpkgs = {
        overlays = [ ];
        args = { };
      };
      shellPkgs = import nixpkgs (
        {
          inherit system;
          overlays = final.nixpkgs.overlays;
        }
        // final.nixpkgs.args
      );
    }
  );
in
{
  makeShell =
    firstLayer:
    _mkBuilder [
      seedLayer
      firstLayer
    ];

  mkOverlay =
    overlaidPackages: final: prev:
    lib.foldl' (acc: elem: acc // (elem final prev)) { } overlaidPackages;

  mkPythonOverlay = overlaidPythonPackages: final: prev: {
    python3 = prev.python3.override {
      packageOverrides =
        pyFinal: pyPrev:
        lib.foldl' (acc: elem: acc // (elem final prev pyFinal pyPrev)) { } overlaidPythonPackages;
    };

    python3Packages = final.python3.pkgs;
  };

  mkPythonClosure =
    pkgs: pythonPackages:
    pkgs.python3.withPackages (ps: lib.foldl' (acc: flist: acc ++ (flist ps)) [ ] pythonPackages);
}
