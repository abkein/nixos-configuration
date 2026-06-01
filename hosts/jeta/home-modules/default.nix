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
    ./dot-config-files.nix
    ./files.nix
    ./waybar.nix
    ./dunst.nix
    ./zotero.nix
    ./ssh.nix
    # ./wofi.nix
  ];
}
