{ mylib, lib }:
let
  _flattenAttrsSep =
    self: prefix: sep: attrs:
    let
      mkAttrName = path: lib.concatStringsSep sep path;
      mkBaseCase = path: value: { "${mkAttrName path}" = value; };
    in
    lib.concatMapAttrs (
      name: value:
      let
        path = prefix ++ [ name ];
      in
      if lib.isAttrs value then
        if self.isLiteral value then mkBaseCase path value.value else _flattenAttrsSep self path sep value
      else
        mkBaseCase path value
    ) attrs;

  flattenAttrsSepGuard =
    self: prefix: sep: attrs:
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
        _flattenAttrsSep self prefix sep attrs;

  _flattenAttrsSep' =
    self: sep: attrs:
    flattenAttrsSepGuard self [ ] sep attrs;

  mkFunctor' = mylib.mkFunctor "flattenAttrs";
in
lib.mapAttrs (_: value: mkFunctor' value) {
  flattenAttrsSep = flattenAttrsSepGuard;
  flattenAttrsSep' = _flattenAttrsSep';
  flattenAttrsDot = self: flattenAttrsSepGuard self ".";
  flattenAttrsDot' = self: _flattenAttrsSep' self ".";
}
