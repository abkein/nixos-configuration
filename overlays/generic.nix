self: super: {
  vscode-extensions.vscode-clang-tidy = import ../pkgs/vscode-clang-tidy/vscode-clang-tidy.nix super;
  zotero-addons = super.callPackage ../pkgs/zotero-addons.nix super;
}
