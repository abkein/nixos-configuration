# Recursive merge that concatenates lists and merges attribute sets
# If both values are attribute sets → recurse.
# If both are lists → concatenate.
# Otherwise → override with the second value.
# uniqKeys ensures all keys from both sets are handled without duplicates.
let
    deepMerge = a: b:
    let
        keys = builtins.attrNames a ++ builtins.attrNames b;
        uniqKeys = builtins.removeAttrs (builtins.listToAttrs (map (k: { name = k; value = null; }) keys)) [];
    in
    builtins.mapAttrs (k: _:
        let
        aHas = builtins.hasAttr k a;
        bHas = builtins.hasAttr k b;
        va = if aHas then a.${k} else null;
        vb = if bHas then b.${k} else null;
        in
        if aHas && bHas then
            if builtins.isAttrs va && builtins.isAttrs vb then
            deepMerge va vb
            else if builtins.isList va && builtins.isList vb then
            va ++ vb
            else
            vb
        else if aHas then va else vb
    ) uniqKeys;
in {deepMerge = deepMerge;}
