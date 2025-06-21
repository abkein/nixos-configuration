{ lib, config, pkgs, ... }:
let
  mkExtList = import ./mkExtList.nix {pkgs=pkgs; lib=lib;};
  needed_extensions = import ./needed_exts.nix;
  generic = {
    userSettings = import ./generalUserSettings.nix;
    globalSnippets = import ./generalGlobalSnippets.nix;
    languageSnippets = import ./generalLangSnippets.nix;
  };
  persistent_extensions = [
    "ms-vscode.atom-keybindings"
    "arrterian.nix-env-selector"
    "mechatroner.rainbow-csv"
  ];
  mkProfile = name: {extensions ? [], add ? {}}: generic // { extensions = mkExtList (needed_extensions.general ++ extensions); } // add;
  mkProfiles = profs: builtins.mapAttrs mkProfile profs;
in
{
  programs.vscode =
  {
    enable = true;
    # package = pkgs.vscode-fhs;
    profiles = mkProfiles
    {
      default = {
        extensions = builtins.concatLists (builtins.attrValues needed_extensions);
        add = {
          enableUpdateCheck = false;
          enableExtensionUpdateCheck = false;
        };
      };
      nix = { };
      LaTeX = with needed_extensions; { extensions = LaTeX ++ python; };
      python = with needed_extensions; { extensions = python ++ py-dev ++ dev ++ sonar; };
      cpp = with needed_extensions; { extensions = cpp ++ dev ++ sonar; };
    };
  };
  # ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
  #   {
  #     name = "atom-keybindings";
  #     publisher = "ms-vscode";
  #     version = "3.3.0";
  #     sha256 = "vzOb/DUV44JMzcuQJgtDB6fOpTKzq298WSSxVKlYE4o=";
  #   }
  # ]
}
