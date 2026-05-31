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
  };
}
