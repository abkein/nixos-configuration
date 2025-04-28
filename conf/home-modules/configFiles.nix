let
  generic = {
    enable = true;
    executable = false;
    force = true;
  };
in {
  networkmanager_dmenu = generic // {
    source = ./confs/networkmanager_dmenu.ini;
    target = "networkmanager-dmenu/config.ini";
  };
  swappy = generic // {
    source = ./confs/swappy.conf;
    target = "swappy/config";
  };
}