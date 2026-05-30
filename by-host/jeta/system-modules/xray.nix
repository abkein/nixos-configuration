{ pkgs, ... }:
let
  xray-creds = import ../shadow/xray-creds.nix;
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
      dns = {
        hosts = {
          "connectivitycheck.gstatic.com" = [
            "2a00:1450:400f:802::2003"
            "142.251.143.131"
          ];
          "dns.google" = [
            "2001:4860:4860::8844"
            "2001:4860:4860::8888"
            "8.8.4.4"
            "8.8.8.8"
          ];
          "mozilla.cloudflare-dns.com" = [
            "2a06:98c1:52::4"
            "2803:f800:53::4"
            "172.64.41.4"
            "162.159.61.4"
          ];
          "cloudflare-dns.com" = [
            "2606:4700:4700::1001"
            "2606:4700:4700::1111"
            "1.0.0.1"
            "1.1.1.1"
          ];
          "dns.quad9.net" = [
            "2620:fe::fe:9"
            "2620:fe::fe"
            "149.112.112.112"
            "9.9.9.9"
          ];
          "common.dot.dns.yandex.net" = [
            "2a02:6b8:0:1::feed:0ff"
            "2a02:6b8::feed:0ff"
            "77.88.8.1"
            "77.88.8.8"
          ];
        };
        servers = [
          # {
          #   address = "https://common.dot.dns.yandex.net/dns-query";
          #   # port = 5353;
          #   domains = [
          #     "geosite:category-ru"
          #     "geosite:ru-available-only-inside"
          #     "domain:scienceid.net"
          #     "domain:mipt.tech"
          #     "domain:volet.com"
          #     "domain:aviasales.com"
          #     "domain:websky.aero"
          #     "domain:webskyx.com"
          #     "domain:flysmartavia.com"
          #     "domain:pruffme.com"
          #     "domain:sci-net.xyz"
          #   ];
          #   # expectedIPs = [ "geoip:cn" ];
          #   unexpectedIPs = [
          #     "geoip:cloudflare"
          #     "geoip:ru-blocked"
          #     "geoip:ru-blocked-community"
          #     "geoip:re-filter"
          #     "geoip:cloudflare"
          #     "geoip:cloudfront"
          #     "geoip:facebook"
          #     "geoip:fastly"
          #     "geoip:google"
          #     "geoip:netflix"
          #     "geoip:telegram"
          #     "geoip:twitter"
          #   ];
          #   skipFallback = true;
          #   finalQuery = false;
          #   tag = "yandex-dns";
          # }
          {
            address = "https://dns.google/dns-query";
            # port = 5353;
            # domains = [ "domain:xray.com" ];
            # expectedIPs = [ "geoip:cn" ];
            # unexpectedIPs = [ "geoip:cloudflare" ];
            skipFallback = true;
            finalQuery = false;
            tag = "google-dns";
          }
          {
            address = "https://dns.quad9.net/dns-query";
            # port = 5353;
            # domains = [ "domain:xray.com" ];
            # expectedIPs = [ "geoip:cn" ];
            # unexpectedIPs = [ "geoip:cloudflare" ];
            skipFallback = true;
            finalQuery = false;
            tag = "quad9-dns";
          }
          # {
          #   address = "https://mozilla.cloudflare-dns.com/dns-query";
          #   # port = 5353;
          #   # domains = [ "domain:xray.com" ];
          #   # expectedIPs = [ "geoip:cn" ];
          #   # unexpectedIPs = [ "geoip:cloudflare" ];
          #   skipFallback = false;
          #   finalQuery = false;
          #   tag = "cloudflare-dns-1";
          # }
          # {
          #   address = "https://cloudflare-dns.com/dns-query";
          #   # port = 5353;
          #   # domains = [ "domain:xray.com" ];
          #   # expectedIPs = [ "geoip:cn" ];
          #   # unexpectedIPs = [ "geoip:cloudflare" ];
          #   skipFallback = false;
          #   finalQuery = false;
          #   tag = "cloudflare-dns-2";
          # }
          {
            address = "localhost";
            port = 53;
            # domains = [ "domain:xray.com" ];
            # expectedIPs = [ "geoip:cn" ];
            # unexpectedIPs = [ "geoip:cloudflare" ];
            skipFallback = false;
            finalQuery = true;
            tag = "local-dns";
          }
        ];
        clientIp = "1.2.3.4";
        queryStrategy = "UseIP";
        disableCache = false;
        serveStale = false;
        serveExpiredTTL = 60;
        disableFallback = false;
        disableFallbackIfMatch = false;
        enableParallelQuery = false;
        useSystemHosts = false;
        tag = "dns_inbound";
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
            tag = "inbound_main";
            sniffing = sniffRoute;
          }
          {
            listen = "127.0.0.1";
            port = 1082;
            protocol = "socks";
            settings = {
              auth = "noauth";
              udp = true;
              ip = "127.0.0.1";
              userLevel = 0;
            };
            tag = "inbound_tor";
            sniffing = {
              enabled = false;
            };
          }
          {
            listen = "127.0.0.1";
            port = 1081;
            protocol = "http";
            settings = {
              userLevel = 0;
            };
            tag = "httpproxy";
            sniffing = sniffRoute;
          }
        ];
      outbounds =
        let
          mkYun_vless-reality-xhttp = postfix: address:
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
          mainBalancer = "TheBalancer";
        in
        {
          domainStrategy = "IPOnDemand"; # "IPIfNonMatch"
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
              inboundTag = [
                "inbound_main"
                "httpproxy"
              ];
              outboundTag = "direct";
              ruleTag = "PrivateIPDirect";
            }
            {
              domain = [ "geosite:private" ];
              inboundTag = [
                "inbound_main"
                "httpproxy"
              ];
              outboundTag = "direct";
              ruleTag = "PrivateDomainDirect";
            }
            {
              inboundTag = [ "inbound_tor" ];
              balancerTag = mainBalancer;
              # outboundTag = "${mainOutbound}";
              ruleTag = "TorDirectRoute";
            }
            {
              domain = [ "geosite:category-ads-all" ];
              inboundTag = [ "inbound_main" ];
              outboundTag = "block";
              ruleTag = "ADBlock";
            }
            {
              domain = [ "geosite:category-ads-all" ];
              inboundTag = [ "httpproxy" ];
              outboundTag = "httpblock";
              ruleTag = "ADBlockHTTP";
            }
            {
              domain = [ "geosite:youtube" ];
              inboundTag = [
                "inbound_main"
                "httpproxy"
              ];
              balancerTag = mainBalancer;
              # outboundTag = "${mainOutbound}";
              ruleTag = "YouTubeToByeDPI";
            }
            {
              domain = [ "geosite:ru-available-only-inside" ];
              inboundTag = [
                "inbound_main"
                "httpproxy"
              ];
              outboundTag = "direct";
              ruleTag = "KnownDomesticOnlyDirectDomain";
            }
            {
              ip = [
                "geoip:ddos-guard"
                "geoip:yandex"
                "geoip:ru-whitelist"
              ];
              inboundTag = [
                "inbound_main"
                "httpproxy"
              ];
              outboundTag = "direct";
              ruleTag = "KnownDomesticOnlyDirectIP";
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
              inboundTag = [
                "inbound_main"
                "httpproxy"
              ];
              balancerTag = mainBalancer;
              # outboundTag = "${mainOutbound}";
              ruleTag = "KnownBlockedToProxyDomain";
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
              inboundTag = [
                "inbound_main"
                "httpproxy"
              ];
              balancerTag = mainBalancer;
              # outboundTag = "${mainOutbound}";
              ruleTag = "KnownBlockedToProxyIP";
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
              inboundTag = [
                "inbound_main"
                "httpproxy"
              ];
              outboundTag = "direct";
              ruleTag = "RUDirectDomain";
            }
            {
              ip = [ "geoip:ru" ];
              inboundTag = [
                "inbound_main"
                "httpproxy"
              ];
              outboundTag = "direct";
              ruleTag = "RUDirectIP";
            }
            {
              inboundTag = [
                "inbound_main"
                "httpproxy"
              ];
              balancerTag = mainBalancer;
              # outboundTag = "${mainOutbound}";
              ruleTag = "DefaultProxy";
            }
          ];
          balancers = [
            {
              # tag = mainBalancer;
              tag = "yunBalancer";
              selector = [ "yun-vless-reality-xhttp-v" ];
              fallbackTag = "regnet-vless-reality-Netherlands";
              strategy = {
                type = "leastPing";
                # settings = { }; # only for leastLoad
              };
            }
            {
              tag = mainBalancer;
              # tag = "regnetbalancer";
              selector = [ "regnet-vless-reality-" ];
              fallbackTag = "block";
              strategy = {
                type = "leastPing";
                # settings = { }; # only for leastLoad
              };
            }
          ];
        };
      observatory = {
        subjectSelector = [
          "yun-vless-reality-xhttp-v"
          "regnet-vless-reality-"
        ];
        probeUrl = "https://www.google.com/generate_204";
        probeInterval = "10s";
        enableConcurrency = false;
      };
      burstObservatory = {
        subjectSelector = [
          "yun-vless-reality-xhttp-v"
          "regnet-vless-reality-"
        ];
        pingConfig = {
          # For each outbound, probe 10 times within 10 minutes; specific probe times are random.
          # If they all fail, it will be marked as a faulty node within 10 ~ 20 minutes.
          # After failure, a single successful probe will mark it as a healthy node; at slowest, it takes 10 minutes.
          destination = "https://connectivitycheck.gstatic.com/generate_204";
          connectivity = "";
          interval = "1m";
          sampling = 10;
          timeout = "5s";
          httpMethod = "HEAD";
        };
      };
      policy = {
        levels = {
          "0" = {
            statsUserUplink = true;
            statsUserDownlink = true;
            statsUserOnline = true;
          };
        };
        system = {
          statsInboundUplink = true;
          statsInboundDownlink = true;
          statsOutboundUplink = true;
          statsOutboundDownlink = true;
        };
      };
    };
  };
}
