{ pkgs, ... }:
let
  mainInbound = "vless-reality-xhttp";
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
          "google.com" = [
            "8.8.8.8"
            "8.8.4.4"
          ];
          "dns.google" = [
            "8.8.8.8"
            "8.8.4.4"
          ];
          "dns.cloudflare.com" = [
            "162.159.61.4"
            "172.64.41.4"
          ];
          "mozilla.cloudflare-dns.com" = [
            "162.159.61.4"
            "172.64.41.4"
          ];
          "dns.quad9.net" = [
            "9.9.9.9"
            "149.112.112.112"
          ];
          # Cloudflare DNS
          # | Description | IPv4 | IPv6 |
          # | Standard              | 1.1.1.1 | 2606:4700:4700::1111 |
          # |                       | 1.0.0.1 | 2606:4700:4700::1001 |
          # | Block malware         | 1.1.1.2 | 2606:4700:4700::1112 |
          # |                       | 1.0.0.2 | 2606:4700:4700::1002 |
          # | Block malware & adult | 1.1.1.3 | 2606:4700:4700::1113 |
          # |                       | 1.0.0.3 | 2606:4700:4700::1003 |
        };
        servers = [
          {
            address = "https://8.8.8.8/dns-query";
            # port = 5353;
            # domains = [ "domain:xray.com" ];
            # expectedIPs = [ "geoip:cn" ];
            # unexpectedIPs = [ "geoip:cloudflare" ];
            skipFallback = false;
            finalQuery = false;
            tag = "google-dns-1";
          }
          {
            address = "https://8.8.4.4/dns-query";
            # port = 5353;
            # domains = [ "domain:xray.com" ];
            # expectedIPs = [ "geoip:cn" ];
            # unexpectedIPs = [ "geoip:cloudflare" ];
            skipFallback = false;
            finalQuery = false;
            tag = "google-dns-2";
          }
          {
            address = "https://9.9.9.9/dns-query";
            # port = 5353;
            # domains = [ "domain:xray.com" ];
            # expectedIPs = [ "geoip:cn" ];
            # unexpectedIPs = [ "geoip:cloudflare" ];
            skipFallback = false;
            finalQuery = false;
            tag = "quad9-dns-1";
          }
          {
            address = "https://149.112.112.112/dns-query";
            # port = 5353;
            # domains = [ "domain:xray.com" ];
            # expectedIPs = [ "geoip:cn" ];
            # unexpectedIPs = [ "geoip:cloudflare" ];
            skipFallback = false;
            finalQuery = false;
            tag = "quad9-dns-2";
          }
          {
            address = "https://1.1.1.1/dns-query";
            # port = 5353;
            # domains = [ "domain:xray.com" ];
            # expectedIPs = [ "geoip:cn" ];
            # unexpectedIPs = [ "geoip:cloudflare" ];
            skipFallback = false;
            finalQuery = false;
            tag = "cloudflare-dns-1";
          }
          {
            address = "https://1.0.0.1/dns-query";
            # port = 5353;
            # domains = [ "domain:xray.com" ];
            # expectedIPs = [ "geoip:cn" ];
            # unexpectedIPs = [ "geoip:cloudflare" ];
            skipFallback = false;
            finalQuery = false;
            tag = "cloudflare-dns-2";
          }
          # {
          #   address = "https://77.88.8.8/dns-query";
          #   # port = 5353;
          #   domains = [ "geosite:category-ru" ];
          #   expectedIPs = [ "geoip:ru" ];
          #   # unexpectedIPs = [ "geoip:cloudflare" ];
          #   skipFallback = true;
          #   finalQuery = false;
          #   tag = "yandex-dns-1";
          # }
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
          mkClient = client: {
            id = client.id;
            level = 0;
            email = client.email;
            flow = "xtls-rprx-vision";
            # reverse = {};
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
            listen = "::";
            port = 443;
            protocol = "vless";
            settings = {
              clients = map mkClient xray-creds.clients;
              decryption = xray-creds.decryption;
              # fallbacks = [
              #   {
              #     dest = 80;
              #   }
              # ];
            };
            streamSettings = {
              network = "xhttp";
              security = "reality";
              realitySettings = {
                show = false;
                target = "www.microsoft.com:443";
                xver = 0;
                serverNames = [
                  "www.microsoft.com"
                  "microsoft.com"
                ];
                privateKey = xray-creds.privateKey;
                minClientVer = "26.2.5";
                shortIds = builtins.map (client: client.shortId) xray-creds.clients;
                mldsa65Seed = xray-creds.mldsa65Seed;
              };
              xhttpSettings = {
                path = "/api/v1/data";
                mode = "stream-one"; # "auto";
                extra = {
                  xPaddingBytes = "100-1000";
                };
              };
            };
            tag = "vless-reality-xhttp";
            sniffing = sniffRoute;
          }
          # {
          #   listen = "127.0.0.1";
          #   port = 1080;
          #   protocol = "socks";
          #   settings = {
          #     auth = "noauth";
          #     udp = true;
          #     ip = "127.0.0.1";
          #     userLevel = 0;
          #   };
          #   tag = "inbound_main";
          #   sniffing = sniffRoute;
          # }
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
          #   sniffing = sniffRoute;
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
      outbounds = [
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
      ];
      routing = {
        domainStrategy = "IPOnDemand";
        rules = [
          {
            inboundTag = [ "in-api" ];
            outboundTag = "api";
            ruleTag = "APIDirectRoute";
          }
          {
            domain = [ "geosite:category-ads-all" ];
            inboundTag = [ mainInbound ];
            outboundTag = "block";
            ruleTag = "ADBlock";
          }
          {
            domain = [ "geosite:category-ads-all" ];
            inboundTag = [ mainInbound ];
            protocol = [ "http" ];
            outboundTag = "httpblock";
            ruleTag = "ADBlock2";
          }
          {
            domain = [ "geosite:ru-available-only-inside" ];
            inboundTag = [
              "inbound_main"
              "httpproxy"
            ];
            outboundTag = "block";
            ruleTag = "BlockKnownDomesticOnlyDomain";
          }
          {
            ip = [
              "geoip:ddos-guard"
              "geoip:yandex"
            ];
            inboundTag = [
              "inbound_main"
              "httpproxy"
            ];
            outboundTag = "block";
            ruleTag = "BlockKnownDomesticOnlyIP";
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
            ];
            inboundTag = [ mainInbound ];
            outboundTag = "direct";
            ruleTag = "KnownBlockedToProxyIP";
          }
          {
            domain = [
              "geosite:binance"
              "geosite:telegram"
              "geosite:reddit"
              "geosite:facebook"
              "geosite:twitter"
              "geosite:youtube"
              "geosite:google-gemini"
              "geosite:google"
              "geosite:instagram"
              "domain:habr.com"
              "domain:ident.me"
              "domain:notebooklm.google"
              "domain:notebooklm.google.com"
            ];
            inboundTag = [ mainInbound ];
            outboundTag = "direct";
            ruleTag = "KnownBlockedToProxyDomain";
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
            ];
            inboundTag = [ mainInbound ];
            outboundTag = "block";
            ruleTag = "GEOSITE_RUBlock";
          }
          {
            ip = [ "geoip:ru" ];
            inboundTag = [ mainInbound ];
            outboundTag = "block";
            ruleTag = "IP_RUBlock";
          }
          {
            ip = [
              "10.0.0.0/8"
              "fc00::/7"
              "fe80::/10"
              "::1"
              "geoip:private"
            ];
            inboundTag = [ mainInbound ];
            outboundTag = "block";
            ruleTag = "PrivateBlock";
          }
          {
            inboundTag = [ mainInbound ];
            outboundTag = "direct";
            ruleTag = "DefaultProxy";
          }
        ];
        balancers = [ ];
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
