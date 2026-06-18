{ mylib, lib }:
let
  _apply =
    function: argument:
    if lib.isFunction function then
      function argument
    else if lib.isAttrs function then
      if function ? __functor then function argument else function
    else
      throw "mylib: application error: neither a function, nor an attrset passed, got: `${lib.typeOf function}`.";
in
rec {
  lazyMerge =
    mergeOp: f1: f2:
    lib.fix (final: mergeOp (_apply f1 final) (_apply f2 final));
  lazyMerge' = f1: f2: lib.fix (final: (_apply f1 final) // (_apply f2 final));
  lazyMergeDeep = lazyMerge mylib.deepMerge;
  lazyMergeList =
    mergeOp: functions:
    lib.fix (final: lib.foldl' (prev: f: mergeOp prev (_apply (_apply f final) prev)) { } functions);
  lazyMergeListDeep = lazyMergeList mylib.deepMerge;
}
