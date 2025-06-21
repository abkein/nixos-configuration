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
  mkProfile = name: {extensions, add ? {}}: generic // { extensions = mkExtList (extensions ++ persistent_extensions); } // add;
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
        extensions = needed_extensions;
        add = {
          enableUpdateCheck = false;
          enableExtensionUpdateCheck = false;
        };
      };
      nix = {
        extensions = [
          "jnoortheen.nix-ide"
        ];
      };
      LaTeX = {
        extensions = [
          "funkyremi.vscode-google-translate"
          "james-yu.latex-workshop"
          "ms-ceintl.vscode-language-pack-ru"
          "valentjn.vscode-ltex"
          "yzhang.markdown-all-in-one"
          "mammothb.gnuplot"
          "trond-snekvik.simple-rst"
        ];
      };
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
