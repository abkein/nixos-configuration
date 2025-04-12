age:
let
  mainOutbound = "yun";
  readSecret = name: builtins.readFile age.secrets.${name}.path;
in
{
  log = { loglevel = "info"; };
  inbounds = [
    {
      port = 1080;
      listen = "127.0.0.1";
      protocol = "socks";
      settings = {
        udp = true;
        ip = "127.0.0.1";
        userLevel = 0;
      };
      tag = "inbound_main";
      sniffing = {
        enabled = true;
        destOverride = [ "http" "tls" ];
      };
    }
    {
      port = 1081;
      listen = "127.0.0.1";
      protocol = "http";
      settings = {
        udp = true;
        ip = "127.0.0.1";
        userLevel = 0;
      };
      tag = "httpproxy";
      sniffing = {
        enabled = true;
        destOverride = [ "http" "tls" ];
      };
    }
  ];
  outbounds = [
    {
      tag = "generic";
      protocol = "vless";
      settings = {
        vnext = [{
          address = "hk-full.privateip.net";
          port = 443;
          users = [{
            id = "09e82ca7-1b3b-474d-9476-f1004701bb6f";
            encryption = "none";
          }];
        }];
      };
      streamSettings = {
        network = "ws";
        security = "tls";
        wsSettings = { path = "/VLESS"; };
        tlsSettings = { serverName = "hk-full.privateip.net"; };
      };
    }
    {
      tag = "yun";
      protocol = "vless";
      settings = {
        vnext = [{
          address = "185.250.180.233";
          port = 443;
          users = [{
            id = "47ca8be6-837f-581d-8de5-1b1889e79743";
            flow = "xtls-rprx-vision";
            encryption = "none";
            level = 0;
          }];
        }];
      };
      streamSettings = {
        network = "tcp";
        security = "reality";
        realitySettings = {
          show = true;
          fingerprint = "firefox";
          serverName = "yahoo.com";
          publicKey = "yEuTz9-TnBDI9t8MlUvjovJDeI6NYIqv9aDpWq96NzM";
          shortId = "427e2187b7034f09";
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
  ];
  routing = {
    domainStrategy = "IPIfNonMatch";
    domainMatcher = "hybrid";
    rules = [
      {
        domainMatcher = "hybrid";
        type = "field";
        domain = [ "geosite:category-ads-all" ];
        inboundTag = [ "inbound_main" "httpproxy" ];
        outboundTag = "block";
      }
      {
        domainMatcher = "hybrid";
        type = "field";
        domain = [
          "geosite:facebook"
          "geosite:twitter"
          "domain:instagram.com"
          "domain:gemini.google.com"
          "domain:habr.com"
          "domain:ident.me"
          "domain:2ip.ru"
        ];
        inboundTag = [ "inbound_main" "httpproxy" ];
        outboundTag = "${mainOutbound}";
      }
      {
        domainMatcher = "hybrid";
        type = "field";
        domain = [
          "domain:ru"
          "geosite:google"
          "geosite:telegram"
          "domain:izhavia.su"
        ];
        inboundTag = [ "inbound_main" "httpproxy" ];
        outboundTag = "direct";
      }
      {
        domainMatcher = "hybrid";
        type = "field";
        ip = [
          "10.0.0.0/8"
          "fc00::/7"
          "fe80::/10"
          "::1"
          "geoip:ru"
          "geoip:private"
        ];
        inboundTag = [ "inbound_main" "httpproxy" ];
        outboundTag = "direct";
      }
      {
        domainMatcher = "hybrid";
        type = "field";
        inboundTag = [ "inbound_main" "httpproxy" ];
        outboundTag = "${mainOutbound}";
      }
    ];
    balancers = [ ];
  };
}
