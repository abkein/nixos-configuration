{ lib }:
let
  entries = lib.readDir ./.;

  files = lib.filter (
    name: entries.${name} == "regular" && name != "default.nix" && lib.hasSuffix ".nix" name
  ) (lib.attrNames entries);

  importFile = self: file: import (./. + "/${file}") { inherit lib self; };

  mkFunctor = name: func: rec {
    inherit name;
    __functor = func;
    literal = value: {
      __myLibSpecial = name;
      inherit value;
    };
    isLiteral =
      value: (lib.isAttrs value) && (value ? __myLibSpecial) && (value.__myLibSpecial == name);
  };
in
lib.fix (self: lib.foldl' (acc: file: acc // (importFile self file)) { inherit mkFunctor; } files)
