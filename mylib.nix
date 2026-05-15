lib: rec {
  flattenAttrsDot =
    prefix: attrs:
    lib.concatMapAttrs (
      name: value:
      let
        path = prefix ++ [ name ];
      in
      if lib.isAttrs value then
        flattenAttrsDot path value
      else
        {
          "${lib.concatStringsSep "." path}" = value;
        }
    ) attrs;

  flattenAttrsDot' = attrs: flattenAttrsDot [ ] attrs;
}
