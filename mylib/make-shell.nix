# make-shell.nix
{ lib, pkgs }:

let
  emptyDef = {
    ctx = { };
    vscodeSettings = { };
    shellArgs = { };
    shellHook = "";
  };

  joinHooks = hooks: lib.concatStringsSep "\n" (builtins.filter (x: x != null && x != "") hooks);

  mergeListAttr =
    name: a: b:
    lib.optionalAttrs (builtins.hasAttr name a || builtins.hasAttr name b) {
      ${name} = (a.${name} or [ ]) ++ (b.${name} or [ ]);
    };

  mergeShellArgs =
    a: b:
    let
      merged = lib.recursiveUpdate a b;
    in
    merged
    // mergeListAttr "packages" a b
    // mergeListAttr "buildInputs" a b
    // mergeListAttr "nativeBuildInputs" a b
    // mergeListAttr "inputsFrom" a b
    // lib.optionalAttrs (builtins.hasAttr "env" a || builtins.hasAttr "env" b) {
      env = lib.recursiveUpdate (a.env or { }) (b.env or { });
    }
    // lib.optionalAttrs (builtins.hasAttr "shellHook" a || builtins.hasAttr "shellHook" b) {
      shellHook = joinHooks [
        (a.shellHook or "")
        (b.shellHook or "")
      ];
    };

  normalizeDef = def: emptyDef // def;

  mergeDef =
    old: new:
    let
      a = normalizeDef old;
      b = normalizeDef new;
    in
    {
      ctx = lib.recursiveUpdate a.ctx b.ctx;
      vscodeSettings = lib.recursiveUpdate a.vscodeSettings b.vscodeSettings;
      shellArgs = mergeShellArgs a.shellArgs b.shellArgs;
      shellHook = joinHooks [
        a.shellHook
        b.shellHook
      ];
    };

  overrideWith = old: new: old // (if builtins.isFunction new then new old else new);

  mkBuilder =
    {
      layers,
      defaultArgs ? { },
    }:
    let
      eval =
        callArgs:
        let
          args = defaultArgs // callArgs;
        in
        lib.fix (
          finalCtx:
          let
            merged = lib.foldl' mergeDef emptyDef (map (layer: normalizeDef (layer finalCtx)) layers);
          in
          args
          // merged.ctx
          // {
            ctx = lib.recursiveUpdate (args.ctx or { }) merged.ctx;

            vscodeSettings = lib.recursiveUpdate (args.vscodeSettings or { }) merged.vscodeSettings;

            shellArgs = mergeShellArgs (args.shellArgs or { }) merged.shellArgs;

            shellHook = joinHooks [
              (args.shellHook or "")
              merged.shellHook
            ];
          }
        );

      instantiateRaw =
        callArgs:
        let
          finalCtx = eval callArgs;

          shellArgsWithoutHook = builtins.removeAttrs finalCtx.shellArgs [ "shellHook" ];

          shellArgHook = finalCtx.shellArgs.shellHook or "";
        in
        pkgs.mkShell (
          shellArgsWithoutHook
          // {
            shellHook = joinHooks [
              shellArgHook
              finalCtx.shellHook
            ];
          }
        );

      self = {
        __functor = self: args: self.instantiate args;

        instantiate = args: lib.makeOverridable instantiateRaw args;

        extend =
          layer:
          mkBuilder {
            layers = layers ++ [ layer ];
            inherit defaultArgs;
          };

        override =
          newDefaults:
          mkBuilder {
            inherit layers;
            defaultArgs = overrideWith defaultArgs newDefaults;
          };

        # Useful for debugging without constructing the shell derivation.
        debug = eval;
      };
    in
    self;

  makeShell = firstLayer: mkBuilder { layers = [ firstLayer ]; };
in
{
  inherit makeShell;
}
