{ lib, config, pkgs, ... }:
let
  mkExtList = import ./mkExtList {pkgs=pkgs; lib=lib;};
  needed_extensions = import ./needed_exts.nix;
  generic = {
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    userSettings = import ./generalUserSettings.nix;
    globalSnippets = import ./generalGlobalSnippets.nix;
    languageSnippets = import ./generalLangSnippets;
  };
  mkProfile = {name, extensions}:
  let
    tmp = generic // { extensions = mkExtList extensions; };
  in
  { ${name} = tmp; };
in
{
  programs.vscode =
  {
    enable = true;
    package = pkgs.vscode-fhs;
    profiles = lib.foldl' (acc: prof: acc // (mkProfile prof)) {}
    [
      {
        name = "default";
        extensions = needed_extensions;
      }
      {
        name = "LaTeX";
        extensions = [
          "jnoortheen.nix-ide"
          "funkyremi.vscode-google-translate"
          "james-yu.latex-workshop"
          "mechatroner.rainbow-csv"
          "ms-ceintl.vscode-language-pack-ru"
          "valentjn.vscode-ltex"
          "yzhang.markdown-all-in-one"
          "arrterian.nix-env-selector"
          "mammothb.gnuplot"
          "ms-vscode.atom-keybindings"
          "trond-snekvik.simple-rst"
        ];
      }
    ]
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
