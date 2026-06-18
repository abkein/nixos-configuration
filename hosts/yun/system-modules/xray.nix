{ pkgs, lib, ... }:
let
  xray-creds = import ../shadow/xray-creds.nix;
  network-creds = import ../shadow/network.nix;
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
        clientIp = network-creds.ipv4.address;
        queryStrategy = "UseIP";
        disableCache = true;
        disableFallback = false;
        disableFallbackIfMatch = false;
        enableParallelQuery = false;
        useSystemHosts = true;
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
            listen = "0.0.0.0";
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
                shortIds = map (client: client.shortId) xray-creds.clients;
                mldsa65Seed = xray-creds.mldsa65Seed;
              };
              xhttpSettings = {
                path = "/api/v1/data";
                mode = "auto"; # "stream-one"; #
                extra = {
                  xPaddingBytes = "100-1000";
                };
              };
            };
            tag = "vless-reality-xhttp";
            sniffing = sniffRoute;
          }
          # {
          #   listen = network-creds.ipv6.address;
          #   port = 443;
          #   protocol = "vless";
          #   settings = {
          #     clients = map mkClient xray-creds.clients;
          #     decryption = xray-creds.decryption;
          #     # fallbacks = [
          #     #   {
          #     #     dest = 80;
          #     #   }
          #     # ];
          #   };
          #   streamSettings = {
          #     network = "xhttp";
          #     security = "reality";
          #     realitySettings = {
          #       show = false;
          #       target = "www.microsoft.com:443";
          #       xver = 0;
          #       serverNames = [
          #         "www.microsoft.com"
          #         "microsoft.com"
          #       ];
          #       privateKey = xray-creds.privateKey;
          #       minClientVer = "26.2.5";
          #       shortIds = builtins.map (client: client.shortId) xray-creds.clients;
          #       mldsa65Seed = xray-creds.mldsa65Seed;
          #     };
          #     xhttpSettings = {
          #       path = "/api/v1/data";
          #       mode = "stream-one"; # "auto";
          #       extra = {
          #         xPaddingBytes = "100-1000";
          #       };
          #     };
          #   };
          #   tag = "vless-reality-xhttp-6";
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
      routing =
        let
          mainInbounds = [ "vless-reality-xhttp" ];
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
              outboundTag = "block";
              ruleTag = "PrivateBlock";
            }
            {
              domain = [ "geosite:category-ads-all" ];
              inboundTag = mainInbounds;
              outboundTag = "block";
              ruleTag = "ADBlock";
            }
            {
              domain = [ "geosite:category-ads-all" ];
              inboundTag = mainInbounds;
              protocol = [ "http" ];
              outboundTag = "httpblock";
              ruleTag = "ADBlockHTTP";
            }
            {
              domain = [ "geosite:ru-available-only-inside" ];
              inboundTag = mainInbounds;
              outboundTag = "block";
              ruleTag = "KnownDomesticOnlyDom2Block";
            }
            {
              ip = [
                "geoip:ddos-guard"
                "geoip:yandex"
                "geoip:ru-whitelist"
              ];
              inboundTag = mainInbounds;
              outboundTag = "block";
              ruleTag = "KnownDomesticOnlyIP2Block";
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
              inboundTag = mainInbounds;
              outboundTag = "direct";
              ruleTag = "KnownBlockedIP2Proxy";
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
              inboundTag = mainInbounds;
              outboundTag = "direct";
              ruleTag = "KnownBlockedDom2Proxy";
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
              inboundTag = mainInbounds;
              outboundTag = "block";
              ruleTag = "GEOSITE_RUBlock";
            }
            {
              ip = [ "geoip:ru" ];
              inboundTag = mainInbounds;
              outboundTag = "block";
              ruleTag = "IP_RUBlock";
            }
            {
              inboundTag = mainInbounds;
              outboundTag = "direct";
              ruleTag = "DefaultProxy";
            }
          ];
          balancers = [ ];
        };
    };
  };
}
