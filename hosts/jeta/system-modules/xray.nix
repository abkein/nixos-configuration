{ pkgs, lib, ... }:
let
  xray-creds = import ../shadow/xray-creds.nix;
  universal-xray = import ../../../universal/system-modules/xray_conf.nix { inherit lib; };
in
{
  services.xray = {
    enable = true;
    package = pkgs.xray.override {
      assets = [
        (pkgs.callPackage ../../../pkgs/v2ray-geoip-ru.nix { })
        (pkgs.callPackage ../../../pkgs/v2ray-geosite-ru.nix { })
      ];
    };
    settings = {
      log = {
        # access = "/var/log/xray-access.log";
        # error = "/var/log/xray-error.log";
        loglevel = "info";
        dnsLog = true;
        maskAddress = ""; # empty to no mask
      };
      api = {
        tag = "api";
        listen = "127.0.0.1:8080";
        services = [
          "LoggerService"
          "StatsService"
          "ReflectionService"
        ];
      };
      stats = { };
      policy = universal-xray.policy;
      dns = {
        hosts = universal-xray.dns.hosts;
        servers = universal-xray.dns.servers { enableLocalhost = true; };
        clientIp = "31.173.85.255";
        queryStrategy = "UseIP";
        disableCache = true;
        disableFallback = false;
        disableFallbackIfMatch = false;
        enableParallelQuery = false;
        useSystemHosts = false;
        tag = "dns-inbound";
      };
      inbounds =
        let
          sniffRoute = {
            enabled = true;
            destOverride = [
              "http"
              "tls"
              "quic"
              "fakedns"
            ];
            routeOnly = true;
          };
        in
        [
          {
            listen = "127.0.0.1";
            port = 10085;
            protocol = "dokodemo-door";
            settings = {
              address = "127.0.0.1";
            };
            tag = "in-api";
          }
          {
            listen = "127.0.0.1";
            port = 1080;
            protocol = "socks";
            settings = {
              auth = "noauth";
              udp = true;
              ip = "127.0.0.1";
              userLevel = 0;
            };
            tag = "inbound-socks-4";
            sniffing = sniffRoute;
          }
          {
            listen = "::1";
            port = 1080;
            protocol = "socks";
            settings = {
              auth = "noauth";
              udp = true;
              ip = "::1";
              userLevel = 0;
            };
            tag = "inbound-socks-6";
            sniffing = sniffRoute;
          }
          # {
          #   listen = "127.0.0.1";
          #   port = 1082;
          #   protocol = "socks";
          #   settings = {
          #     auth = "noauth";
          #     udp = true;
          #     ip = "127.0.0.1";
          #     userLevel = 0;
          #   };
          #   tag = "inbound_tor";
          #   sniffing = {
          #     enabled = false;
          #   };
          # }
          # {
          #   listen = "127.0.0.1";
          #   port = 1081;
          #   protocol = "http";
          #   settings = {
          #     userLevel = 0;
          #   };
          #   tag = "httpproxy";
          #   sniffing = sniffRoute;
          # }
        ];
      outbounds =
        let
          mkYun_vless-reality-xhttp =
            postfix: address:
            let
              inherit (xray-creds) yun;
            in
            {
              tag = "yun-vless-reality-xhttp-${postfix}";
              sendThrough = "0.0.0.0";
              protocol = "vless";
              settings = {
                address = address;
                port = yun.port;
                id = yun.id;
                flow = "xtls-rprx-vision";
                encryption = yun.encryption;
                level = 0;
              };
              streamSettings = {
                network = "xhttp";
                security = "reality";
                realitySettings = {
                  show = false;
                  fingerprint = "chrome";
                  serverName = "www.microsoft.com";
                  password = yun.password;
                  shortId = yun.shortId;
                  mldsa65Verify = yun.mldsa65Verify;
                  spiderX = "/fi-fi";
                };
                xhttpSettings = {
                  path = "/api/v1/data";
                  mode = "stream-one"; # "auto";
                  extra = {
                    xPaddingBytes = "100-1000";
                  };
                };
              };
            };
          mkRegnetVLESS3 =
            postfix: addrress:
            let
              inherit (xray-creds) regnet;
            in
            {
              tag = "regnet-vless-reality-${postfix}";
              sendThrough = "0.0.0.0";
              protocol = "vless";
              settings = {
                address = addrress;
                port = regnet.port;
                id = regnet.id;
                flow = "xtls-rprx-vision";
                encryption = "none";
                level = 0;
              };
              streamSettings = {
                network = "raw";
                security = "reality";
                sockopt = {
                  dialerProxy = "fragment";
                };
                realitySettings = {
                  show = false;
                  fingerprint = "chrome";
                  serverName = "iv.okcdn.ru";
                  publicKey = regnet.publicKey;
                  shortId = regnet.shortId;
                };
              };
            };
        in
        [
          # (mkYun_vless-reality-xhttp "v4" "194.124.210.24")
          # (mkYun_vless-reality-xhttp "v6" "2a0d:6c2:24:8125::")
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
        ++ (builtins.map (dest: mkRegnetVLESS3 dest.postfix dest.address) xray-creds.regnet.dests)
        ++ (builtins.map (dest: mkYun_vless-reality-xhttp dest.postfix dest.address) xray-creds.yun.dests);
      routing =
        let
          # mainBalancer = "TheBalancer";
          mainOutbound = "yun-vless-reality-xhttp-v4";
          mainInbounds = [
            "inbound-socks-4"
            "inbound-socks-6"
          ];
        in
        {
          domainStrategy = "IPOnDemand";
          rules = [
            {
              inboundTag = [ "in-api" ];
              outboundTag = "api";
              ruleTag = "APIDirectRoute";
            }
            {
              ip = [
                "127.0.0.1/8"
                "192.168.0.0/16"
                "10.0.0.0/8"
                "::1/128"
                "fc00::/7"
                "fe80::/10"
                "geoip:private"
              ];
              inboundTag = mainInbounds;
              outboundTag = "direct";
              ruleTag = "PrivateIPDirect";
            }
            {
              domain = [ "geosite:private" ];
              inboundTag = mainInbounds;
              outboundTag = "direct";
              ruleTag = "PrivateDomainDirect";
            }
            # {
            #   inboundTag = [ "inbound_tor" ];
            #   # balancerTag = mainBalancer;
            #   outboundTag = mainOutbound;
            #   ruleTag = "TorDirectRoute";
            # }
            {
              domain = [ "geosite:category-ads-all" ];
              protocol = [ "http" ];
              inboundTag = mainInbounds;
              outboundTag = "httpblock";
              ruleTag = "ADBlockHTTP";
            }
            {
              domain = [ "geosite:category-ads-all" ];
              inboundTag = mainInbounds;
              outboundTag = "block";
              ruleTag = "ADBlock";
            }
            # {
            #   domain = [ "geosite:youtube" ];
            #   inboundTag = std-in;
            #   # balancerTag = mainBalancer;
            #   outboundTag = mainOutbound;
            #   ruleTag = "YouTubeToByeDPI";
            # }
            {
              domain = [ "geosite:ru-available-only-inside" ];
              inboundTag = mainInbounds;
              outboundTag = "direct";
              ruleTag = "KnownDomesticOnlyDom2Direct";
            }
            {
              ip = [
                "geoip:ddos-guard"
                "geoip:yandex"
                "geoip:ru-whitelist"
              ];
              inboundTag = mainInbounds;
              outboundTag = "direct";
              ruleTag = "KnownDomesticOnlyIP2Direct";
            }
            {
              domain = [
                "geosite:ru-blocked"
                "geosite:binance"
                "geosite:telegram"
                "geosite:reddit"
                "geosite:twitter"
                "geosite:google"
                "geosite:meta"
                "geosite:refilter"
                "geosite:openai"
                "domain:habr.com"
                "domain:ident.me"
                "domain:notebooklm.google"
                "domain:notebooklm.google.com"
              ];
              inboundTag = mainInbounds;
              # balancerTag = mainBalancer;
              outboundTag = mainOutbound;
              ruleTag = "KnownBlockedDom2Proxy";
            }
            {
              ip = [
                "geoip:ru-blocked"
                "geoip:ru-blocked-community"
                "geoip:re-filter"
                "geoip:cloudflare"
                "geoip:cloudfront"
                "geoip:facebook"
                "geoip:fastly"
                "geoip:google"
                "geoip:netflix"
                "geoip:telegram"
                "geoip:twitter"
                "geoip:tor"
              ];
              inboundTag = mainInbounds;
              # balancerTag = mainBalancer;
              outboundTag = mainOutbound;
              ruleTag = "KnownBlockedIP2Proxy";
            }
            {
              domain = [
                "geosite:category-ru"
                "domain:scienceid.net"
                "domain:mipt.tech"
                "domain:volet.com"
                "domain:aviasales.com"
                "domain:websky.aero"
                "domain:webskyx.com"
                "domain:flysmartavia.com"
                "domain:pruffme.com"
                "domain:sci-net.xyz"
              ];
              inboundTag = mainInbounds;
              outboundTag = "direct";
              ruleTag = "DomRU2Direct";
            }
            {
              ip = [ "geoip:ru" ];
              inboundTag = mainInbounds;
              outboundTag = "direct";
              ruleTag = "IPRU2Direct";
            }
            {
              inboundTag = mainInbounds;
              # balancerTag = mainBalancer;
              outboundTag = mainOutbound;
              ruleTag = "Default2Proxy";
            }
          ];
          # balancers = [
          #   {
          #     # tag = mainBalancer;
          #     tag = "yunBalancer";
          #     selector = [ "yun-vless-reality-xhttp-v" ];
          #     fallbackTag = "regnet-vless-reality-Netherlands";
          #     strategy = {
          #       type = "leastPing";
          #       # settings = { }; # only for leastLoad
          #     };
          #   }
          #   {
          #     # tag = mainBalancer;
          #     tag = "regnetbalancer";
          #     selector = [ "regnet-vless-reality-" ];
          #     fallbackTag = "block";
          #     strategy = {
          #       type = "leastPing";
          #       # settings = { }; # only for leastLoad
          #     };
          #   }
          # ];
        };
      # observatory = {
      #   subjectSelector = [
      #     "yun-vless-reality-xhttp-v"
      #     "regnet-vless-reality-"
      #   ];
      #   probeUrl = "https://www.google.com/generate_204";
      #   probeInterval = "10s";
      #   enableConcurrency = false;
      # };
      # burstObservatory = {
      #   subjectSelector = [
      #     "yun-vless-reality-xhttp-v"
      #     "regnet-vless-reality-"
      #   ];
      #   pingConfig = {
      #     # For each outbound, probe 10 times within 10 minutes; specific probe times are random.
      #     # If they all fail, it will be marked as a faulty node within 10 ~ 20 minutes.
      #     # After failure, a single successful probe will mark it as a healthy node; at slowest, it takes 10 minutes.
      #     destination = "https://connectivitycheck.gstatic.com/generate_204";
      #     connectivity = "";
      #     interval = "1m";
      #     sampling = 10;
      #     timeout = "5s";
      #     httpMethod = "HEAD";
      #   };
      # }
    };
  };
}
