pkgs:
pkgs.vscode-utils.buildVscodeExtension {
  pname = "abkein.vscode-clang-tidy";
  vscodeExtPublisher = "abkein";
  vscodeExtName = "vscode-clang-tidy";
  version = "0.7.0";
  vscodeExtUniqueId = "abkein.vscode-clang-tidy";
  src = ./clang-tidy-ab-kein-fork-0.7.0.vsix;

  nativeBuildInputs = [ pkgs.unzip ];

  unpackPhase = ''
    runHook preUnpack
    mkdir -p source
    unzip -q "$src" -d source
    # VSIX files normally contain an "extension/" top-level directory
    sourceRoot="source/extension"
    runHook postUnpack
  '';
}
