let
  generic = {
    enable = true;
    executable = false;
    force = true;
  };
in {
  networkmanager_dmenu = generic // {
    source = ../confs/networkmanager_dmenu.ini;
    target = "networkmanager-dmenu/config.ini";
  };
  swappy = generic // {
    source = ../confs/swappy.conf;
    target = "swappy/config";
  };
  defshell = generic // {
    source = ../confs/defshell.nix;
    target = "defshell.nix";
  };
  pyshell = generic // {
    source = ../confs/python/pyshell.nix;
    target = "python/pyshell.nix";
  };
  pyreqs = generic // {
    source = ../confs/python/defreqs.txt;
    target = "python/defreqs.txt";
  };
}