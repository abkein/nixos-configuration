{ config, pkgs, lib, ... }:
{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    guiPasswordFile = config.age.secrets."syncthingPass".path;
    guiAddress = "127.0.0.1:8384";  # default
    user = "kein";
    dataDir = "/home/kein";
    settings = {
      devices = {
        "phone-A63" = {
          id = "GIABTJN-E7JIDLE-XP7HU37-HDNAVYG-FI4XKTN-ARMJG3J-32WHYTM-ZFP2MQJ";
          name = "Nothing Phone (1)";
        };
      };
      folders = {
        "Documents" = {
          enable = true;
          id = "TheDocs";
          label = "My documents";
          path = "${config.home.homeDirectory}/Documents";
          devices = [ "phone-A63" ];
          type = "sendreceive";  # default
          versioning = {
            type = "staggered";
            fsPath = "${config.home.homeDirectory}/backup";
            params = {
              cleanInterval = "3600";
              maxAge = "31536000";
            };
          };
        };
      };
      options = {
        limitBandwidthInLan = false;
        localAnnounceEnabled = true;
        localAnnouncePort = 8494;
        relaysEnabled = true;
        urAccepted = 3;
      };
    };
    # tray = {
    #   enable = true;
    # };
    # environment.STNODEFAULTFOLDER = "true";
  };
}