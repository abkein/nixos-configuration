{ ... }:
{
  imports = [
    # ./thunderbird.nix
    ./hypr
    ./vscode/workspaces.nix
    ./gnupg.nix
    ./syncthing.nix
    ./dolphin.nix
    ./firefox.nix
    ./files.nix
    ./waybar.nix
    ./dunst.nix
    ./zotero.nix
    ./ssh.nix
    ./networkmanager_dmenu.nix
    ./keepassxc.nix
    # ./wofi.nix
  ];
}
