lib: rec {
  flattenAttrsDot =
    let
      mkAttrName = path: lib.concatStringsSep "." path;
      mkBaseCase = path: value: { "${mkAttrName path}" = value; };
    in
    prefix: attrs:
    lib.concatMapAttrs (
      name: value:
      let
        path = prefix ++ [ name ];
      in
      if lib.isAttrs value then
        if (value ? __flattenAttrsDotStop) && (value.__flattenAttrsDotStop) then
          if value ? value then
            mkBaseCase path value.value
          else
            throw "Something went wrong during the evaluation of '${mkAttrName}': stop marker present, but not value."
        else
          flattenAttrsDot path value
      else
        mkBaseCase path value
    ) attrs;

  flattenAttrsDot' = attrs: flattenAttrsDot [ ] attrs;

  literal = value: {
    __flattenAttrsDotStop = true;
    inherit value;
  };
}
