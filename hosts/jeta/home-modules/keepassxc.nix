{ pkgs, ... }:
{
  home.packages = [ pkgs.keepassxc ];
  xdg.autostart.entries = [ "${pkgs.keepassxc}/share/applications/org.keepassxc.KeePassXC.desktop" ];
}
