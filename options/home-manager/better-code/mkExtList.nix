{ pkgs, lib, ... }:
nix4vscodeAlways: needed_extensions:
let
  inherit (lib) isDerivation isString;
  flat_extensions = lib.flatten needed_extensions;

  string_extensions = builtins.filter isString flat_extensions;
  raw_extensions = builtins.filter isDerivation flat_extensions;

  parse_extension =
    extension:
    let
      parts = builtins.split "\\." extension;
    in
    if (builtins.length parts) == 3 then
      {
        publisher = builtins.elemAt parts 0;
        name = builtins.elemAt parts 2;
      }
    else
      throw "Better-code: Invalid extension format: ${extension}";
  unparse_extension = { publisher, name }: "${publisher}.${name}";

  has_extension =
    { publisher, name }:
    (builtins.hasAttr publisher pkgs.vscode-extensions)
    && (builtins.hasAttr name (builtins.getAttr publisher pkgs.vscode-extensions));
  get_extension =
    { publisher, name }: builtins.getAttr name (builtins.getAttr publisher pkgs.vscode-extensions);

  parsed_extensions = map parse_extension string_extensions;
  presentExtensions = builtins.filter has_extension parsed_extensions;
  not_presentExtensions = builtins.filter (ext: !has_extension ext) parsed_extensions;

  market_extensions = map get_extension presentExtensions;
  nix4vscode_extensions = map unparse_extension not_presentExtensions;
in
if nix4vscodeAlways then
  ((pkgs.nix4vscode.forVscode string_extensions) ++ raw_extensions)
else
  (
    market_extensions
    ++ (if nix4vscode_extensions == [ ] then [ ] else (pkgs.nix4vscode.forVscode nix4vscode_extensions))
    ++ raw_extensions
  )
