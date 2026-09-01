{ ... }:
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
{
  services.xray.settings.inbounds = [
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
      port = 1081;
      protocol = "socks";
      settings = {
        auth = "noauth";
        udp = true;
        ip = "127.0.0.1";
        userLevel = 0;
      };
      tag = "inbound-nix-4";
      sniffing = sniffRoute;
    }
    {
      listen = "::1";
      port = 1081;
      protocol = "socks";
      settings = {
        auth = "noauth";
        udp = true;
        ip = "::1";
        userLevel = 0;
      };
      tag = "inbound-nix-6";
      sniffing = sniffRoute;
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
}
