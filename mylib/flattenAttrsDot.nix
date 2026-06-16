{ mylib, lib }:
let
  _flattenAttrsDot =
    let
      mkAttrName = path: lib.concatStringsSep "." path;
      mkBaseCase = path: value: { "${mkAttrName path}" = value; };
    in
    self: prefix: attrs:
    lib.concatMapAttrs (
      name: value:
      let
        path = prefix ++ [ name ];
      in
      if lib.isAttrs value then
        if self.isLiteral value then mkBaseCase path value.value else _flattenAttrsDot self path value
      else
        mkBaseCase path value
    ) attrs;

  flattenAttrsDotGuard =
    self: prefix: attrs:
    if (!(lib.isList prefix)) then
      throw "lib: flattenAttrsDot: First argument `prefix` is not a list."
    else if (!(lib.isAttrs attrs)) then
      throw "lib: flattenAttrsDot: Second argument `attrs` is not an attrset."
    else
      let
        errors =
          let
            errors =
              lib.foldl'
                (acc: elem: rec {
                  iteration = acc.iteration + 1;
                  errors =
                    acc.errors
                    ++ (lib.optional (!(lib.isString elem)) "Argument ${iteration}: got `${lib.typeOf elem}`.");
                })
                {
                  iteration = 0;
                  errors = [ ];
                }
                prefix;
          in
          errors.errors;
        errorsMsg = lib.concatStringsSep "\n" errors;
      in
      if errors != [ ] then
        throw "lib: flattenAttrsDot: First argument `prefix` should be a list of strings:\n" + errorsMsg
      else
        _flattenAttrsDot self prefix attrs;

  _flattenAttrsDot' = self: attrs: flattenAttrsDotGuard self [ ] attrs;

  mkFunctor' = mylib.mkFunctor "flattenAttrsDot";
in
{
  flattenAttrsDot = mkFunctor' flattenAttrsDotGuard;
  flattenAttrsDot' = mkFunctor' _flattenAttrsDot';
}
