{ lib, ... }:
let
  universal-xray = import ../../../../universal/system-modules/xray_conf.nix { inherit lib; };
in
{
  imports = [
    ./inbounds.nix
    ./outbounds.nix
    ./routing.nix
  ];

  services.xray = {
    enable = true;
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
      # observatory = {
      #   subjectSelector = [
      #     # "yun-vless-reality-xhttp-v"
      #     # "regnet-vless-reality-"
      #     "ussr-reality-"
      #   ];
      #   probeUrl = "https://www.google.com/generate_204";
      #   probeInterval = "10s";
      #   enableConcurrency = false;
      # };
      burstObservatory = {
        subjectSelector = [
          # "yun-vless-reality-xhttp-v"
          # "regnet-vless-reality-"
          "ussr-reality-"
        ];
        pingConfig = {
          # For each outbound, probe 10 times within 10 minutes; specific probe times are random.
          # If they all fail, it will be marked as a faulty node within 10 ~ 20 minutes.
          # After failure, a single successful probe will mark it as a healthy node; at slowest, it takes 10 minutes.
          destination = "https://connectivitycheck.gstatic.com/generate_204";
          connectivity = "https://connectivitycheck.gstatic.com/generate_204";
          interval = "3m";
          sampling = 10;
          timeout = "5s";
          httpMethod = "HEAD";
        };
      };
    };
  };
}
