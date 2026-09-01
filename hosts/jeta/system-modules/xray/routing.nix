{ ... }: {
  services.xray.settings.routing =
    let
      mainBalancer = "TheBalancer";
      # mainOutbound = "yun-vless-reality-xhttp-v4";
      mainInbounds = [
        "inbound-socks-4"
        "inbound-socks-6"
      ];
      nixInbounds = [
        "inbound-nix-4"
        "inbound-nix-6"
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
          inboundTag = mainInbounds ++ nixInbounds;
          outboundTag = "direct";
          ruleTag = "PrivateIPDirect";
        }
        {
          domain = [ "geosite:private" ];
          inboundTag = mainInbounds ++ nixInbounds;
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
          domain = [
            "geosite:ru-available-only-inside"
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
          balancerTag = mainBalancer;
          # outboundTag = mainOutbound;
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
          balancerTag = mainBalancer;
          # outboundTag = mainOutbound;
          ruleTag = "KnownBlockedIP2Proxy";
        }
        {
          domain = [ "geosite:category-ru" ];
          inboundTag = mainInbounds ++ nixInbounds;
          outboundTag = "direct";
          ruleTag = "DomRU2Direct";
        }
        {
          ip = [ "geoip:ru" ];
          inboundTag = mainInbounds ++ nixInbounds;
          outboundTag = "direct";
          ruleTag = "IPRU2Direct";
        }
        {
          inboundTag = mainInbounds;
          balancerTag = mainBalancer;
          # outboundTag = mainOutbound;
          ruleTag = "Default2Proxy";
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
          # tag = mainBalancer;
          tag = "regnetBalancer";
          selector = [ "regnet-vless-reality-" ];
          fallbackTag = "block";
          strategy = {
            type = "leastPing";
            # settings = { }; # only for leastLoad
          };
        }
        {
          tag = mainBalancer;
          # tag = "ussrBalancer";
          selector = [ "ussr-reality-" ];
          fallbackTag = "ussr-bridge-reality";
          strategy = {
            type = "leastPing";
            # settings = { }; # only for leastLoad
          };
        }
      ];
    };
}
