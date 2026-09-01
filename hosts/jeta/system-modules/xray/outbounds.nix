{ lib, ... }:
let
  xray-creds = import ../../shadow/xray-creds.nix;
  generators = import ./outbound-generators.nix { inherit lib xray-creds; };
in
{
  services.xray.settings.outbounds = [
    {
      tag = "fragment";
      protocol = "freedom";
      settings = {
        userLevel = 0;
        fragment = {
          length = "80-250";
          interval = "10-100";
          packets = "tlshello";
        };
      };
    }
    {
      tag = "direct";
      protocol = "freedom";
    }
    {
      tag = "block";
      protocol = "blackhole";
    }
    {
      tag = "httpblock";
      protocol = "blackhole";
      settings = {
        responce = {
          type = "http";
        };
      };
    }
  ]
  ++ (map (dest: generators.mkRegnetVLESS3 dest.postfix dest.address) xray-creds.regnet.dests)
  ++ (map (dest: generators.mkYun_vless-reality-xhttp dest.postfix dest.address) xray-creds.yun.dests)
  ++ generators.ussr-list;
}
