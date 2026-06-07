# Do not include it into your confuguration via `imports = [];`.
# It won't work. Use it as
# ```nix
# let
#   basic-xray = import /path/to/xray_conf.nix { inherit lib; };
# in
#   services.xray.settings.dns.hosts = basic-xray.dns.hosts
# ```

{ lib, ... }:
{
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
    servers =
      {
        enableGoogle ? false,
        enableQuad9 ? false,
        enableCloudFlare ? false,
        enableLocalhost ? false,
      }:
      [
        {
          address = "https://dns.google/dns-query";
          skipFallback = true;
          finalQuery = false;
          tag = "google-dns";
        }
        {
          address = "https://dns.quad9.net/dns-query";
          skipFallback = true;
          finalQuery = false;
          tag = "quad9-dns";
        }
      ]
      ++ (lib.optionals enableCloudFlare [
        {
          address = "https://mozilla.cloudflare-dns.com/dns-query";
          skipFallback = false;
          finalQuery = false;
          tag = "cloudflare-dns-1";
        }
        {
          address = "https://cloudflare-dns.com/dns-query";
          skipFallback = false;
          finalQuery = false;
          tag = "cloudflare-dns-2";
        }
      ])
      ++ (lib.optionals enableLocalhost [
        {
          address = "localhost";
          port = 53;
          skipFallback = false;
          finalQuery = true;
          tag = "local-dns";
        }
      ]);
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
}

# Yandex does not use JSON
# {
#   address = "https://common.dot.dns.yandex.net/dns-query";
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
