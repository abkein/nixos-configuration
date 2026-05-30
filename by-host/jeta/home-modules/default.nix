{ ... }:
{
  imports = [
    # ./thunderbird.nix
    ./vscode/better-code/better-code.nix
    ./vscode/workspaces.nix
    ./gnupg.nix
    ./syncthing.nix
    ./dolphin.nix
    ./firefox.nix
    ./dot-config-files.nix
    ./files.nix
    ./waybar.nix
    ./zsh.nix
    ./hypr/hypr.nix
    ./dunst.nix
    ./zotero/zotero.nix
    ./zotero.nix
    ./ssh.nix
    ./wofi.nix
  ];
}
