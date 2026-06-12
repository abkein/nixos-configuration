{ ... }:
{
  imports = [
    ./hypr
    ./desktop-utils
    ./vscode
    ./firefox.nix
    ./ssh.nix
    ./keepassxc.nix
    ./gnupg.nix
    ./zotero.nix
    ./syncthing.nix
    ./files.nix
    ./fixes.nix
    # ./thunderbird.nix
  ];
}
