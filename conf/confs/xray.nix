age:
let
  mainOutbound = "yun";
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
          address = builtins.readFile age.secrets.xray_generic_address.secret.path;
          port = 443;
          users = [{
            id = builtins.readFile age.secrets.xray_generic_ID.secret.path;
            encryption = "none";
          }];
        }];
      };
      streamSettings = {
        network = "ws";
        security = "tls";
        wsSettings = { path = "/VLESS"; };
        tlsSettings = { serverName = builtins.readFile age.secrets.xray_generic_ServerName.secret.path; };
      };
    }
    {
      tag = "yun";
      protocol = "vless";
      settings = {
        vnext = [{
          address = builtins.readFile age.secrets.xray_yun_address.secret.path;
          port = 443;
          users = [{
            id = builtins.readFile age.secrets.xray_yun_ID.secret.path;
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
          shortId = builtins.readFile age.secrets.xray_yun_ShortID.secret.path;
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
