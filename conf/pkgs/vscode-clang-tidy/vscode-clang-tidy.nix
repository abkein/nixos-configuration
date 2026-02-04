pkgs:
pkgs.vscode-utils.buildVscodeExtension {
  pname = "abkein.vscode-clang-tidy";
  version = "0.7.0";
  vscodeExtUniqueId = "abkein.vscode-clang-tidy";
  src = ./vscode/myext.vsix;
}
