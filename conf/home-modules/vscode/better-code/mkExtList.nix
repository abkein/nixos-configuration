{pkgs, lib, ...}: needed_extensions:
let
  parse_extension = extension:
    let parts = builtins.split "\\." extension; in
    if (builtins.length parts) == 3 then {
      publisher = builtins.elemAt parts 0;
      name = builtins.elemAt parts 2;
    } else throw "Invalid extension format: ${extension}";
  unparse_extension = {publisher, name}: "${publisher}.${name}";

  has_extension = {publisher, name}: (builtins.hasAttr publisher pkgs.vscode-extensions) && (builtins.hasAttr name (builtins.getAttr publisher pkgs.vscode-extensions));
  get_extension = {publisher, name}: builtins.getAttr name (builtins.getAttr publisher pkgs.vscode-extensions);

  # plugins = (import ./vscode_exts.nix) { inherit pkgs lib; };
  # needed_extensions = import ./needed_exts.nix;

  parsed_extensions = builtins.map parse_extension needed_extensions;
  presentExtensions = builtins.filter has_extension parsed_extensions;
  market_extensions = builtins.map get_extension presentExtensions;

  not_presentExtensions = builtins.filter (ext: !has_extension ext) parsed_extensions;
  nix4vscode_extensions = builtins.map unparse_extension not_presentExtensions;
in market_extensions ++ (if builtins.length nix4vscode_extensions == 0 then [] else (pkgs.nix4vscode.forVscode nix4vscode_extensions))
