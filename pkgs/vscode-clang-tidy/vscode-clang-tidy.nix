pkgs:
pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  vsix = ./clang-tidy-ab-kein-fork-0.7.1.vsix;
  mktplcRef = {
    name = "vscode-clang-tidy";
    publisher = "abkein";
    version = "0.7.1";
  };
}
