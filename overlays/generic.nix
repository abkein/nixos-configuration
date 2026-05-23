self: super: {
  vscode-extensions.vscode-clang-tidy = import ../pkgs/vscode-clang-tidy/vscode-clang-tidy.nix super;
  zotero-addons = super.callPackage ../pkgs/zotero-addons.nix { };
  ibus-engines = super.ibus-engines // {
    typing-booster-unwrapped = super.callPackage ../pkgs/ibus-typing-booster { };
  };
}
