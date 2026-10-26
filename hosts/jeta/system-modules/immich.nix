{ lib, ... }:
let
  driveMount = "mnt-sms.mount";
in
{
  services.immich = {
    enable = true;
    host = "0.0.0.0";
    openFirewall = true;
    mediaLocation = "/mnt/sms/immich/";
    accelerationDevices = null;
  };

  systemd.services = {
    immich-server = {
      wantedBy = lib.mkForce [ driveMount ];
      requires = [
        "redis-immich.service"
        "immich-machine-learning.service"
      ];
      bindsTo = [ driveMount ];
      after = [
        driveMount
        "redis-immich.service"
        "immich-machine-learning.service"
      ];
      unitConfig = {
        StartLimitIntervalSec = "600s";
        StartLimitBurst = 1;
      };
    };

    redis-immich = {
      wantedBy = lib.mkForce [ ];
      bindsTo = [ driveMount ];
      after = [ driveMount ];
      unitConfig.StopWhenUnneeded = true;
    };

    immich-machine-learning = {
      wantedBy = lib.mkForce [ ];
      bindsTo = [ driveMount ];
      after = [ driveMount ];
      unitConfig.StopWhenUnneeded = true;
    };
  };
}
