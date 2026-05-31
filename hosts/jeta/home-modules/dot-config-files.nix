{ ... }:
let
  generic = {
    enable = true;
    executable = false;
    force = true;
  };
in
{
  xdg.configFile = {
    networkmanager_dmenu = generic // {
      source = ../confs/networkmanager_dmenu.ini;
      target = "networkmanager-dmenu/config.ini";
    };
  };
}
