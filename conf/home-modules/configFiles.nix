let
  generic = {
    enable = true;
    executable = false;
    force = true;
  };
in {
  pythonrc = {
    enable = true;
    executable = true;
    force = true;
    source = ../confs/python/pythonrc.py;
    target = "python/pythonrc";
  };
  pypackages_overlay = generic // {
    source = ../overlays/pypackages.nix;
    target = "nixpkgs/overlays/pypackages.nix";
  };
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
  simple-notebook = generic // {
    source = ../confs/python/simple.ipynb;
    target = "python/simple.ipynb";
  };
  hyprlock-te = generic // {
    target = "hyprlock/te.markup";
    text = ''
      <markup>
        <span color="#E2E2E2" bgcolor="#2980B9" bgalpha="50%" face="Gabarito" size="20pt">
          Alles muss sich veraendern
        </span>
        <span color="#E2E2E2" bgcolor="#2980B9" bgalpha="50%" face="Gabarito" size="20pt">
          or no
        </span>
      </markup>
    '';
  };
  # hyprland-regreet = generic // {
  #   source = ../confs/Hyprland-regreet.conf;
  #   target = "hypr/hyprland-regreet.conf";
  # };
}
