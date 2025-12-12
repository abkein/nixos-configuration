{ lib, config, pkgs, ... }:
{
  programs.vscode =
  {
    enable = true;
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
