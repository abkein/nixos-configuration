self: super: {
  vscode-extensions.vscode-clang-tidy = import ../pkgs/vscode-clang-tidy/vscode-clang-tidy.nix self;
  zotero-addons = self.callPackage ../pkgs/zotero-addons.nix { };
  ibus-engines = super.ibus-engines // {
    typing-booster-unwrapped = self.callPackage ../pkgs/ibus-typing-booster { };
  };
  vimix-icon-theme = self.callPackage ../pkgs/vimix-icon-theme.nix { };
}
