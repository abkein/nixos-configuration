# Recursive merge that concatenates lists and merges attribute sets
# If both values are attribute sets → recurse.
# If both are lists → concatenate.
# Otherwise → override with the second value.
# uniqKeys ensures all keys from both sets are handled without duplicates.
{ mylib, lib }:
let
  _deepMergeCore =
    self: a: b:
    let
      keys = lib.attrNames a ++ lib.attrNames b;
      uniqKeys = lib.removeAttrs (lib.listToAttrs (
        lib.map (k: {
          name = k;
          value = null;
        }) keys
      )) [ ];
    in
    lib.mapAttrs (
      k: _:
      let
        aHas = lib.hasAttr k a;
        bHas = lib.hasAttr k b;
        va = if aHas then a.${k} else null;
        vb = if bHas then b.${k} else null;
      in
      if aHas && bHas then
        if (self.isLiteral va) || (self.isLiteral vb) then
          vb
        else if lib.isAttrs va && lib.isAttrs vb then
          _deepMergeCore self va vb
        else if lib.isList va && lib.isList vb then
          va ++ vb
        else
          vb
      else if aHas then
        va
      else
        vb
    ) uniqKeys;

  deepMergeGuard =
    self: va: vb:
    if (self.isLiteral va) || (self.isLiteral vb) then
      vb
    else if lib.isAttrs va && lib.isAttrs vb then
      _deepMergeCore self va vb
    else if lib.isList va && lib.isList vb then
      va ++ vb
    else
      vb;

  _deepMergeList =
    self: list:
    lib.foldl' (acc: value: if acc == null then value else deepMergeGuard self acc value) null list;

  mkFunctor' = mylib.mkFunctor "deepMerge";
in
{
  deepMerge = mkFunctor' deepMergeGuard;
  deepMergeList = mkFunctor' _deepMergeList;
}
