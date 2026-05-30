{ cfg, ... }:
let
  network = import ../shadow/network.nix;
in
{
  networking = {
    hostName = cfg.hostname;
    useDHCP = false;
    # nameservers = [
    #   "1.1.1.1"
    #   "8.8.8.8"
    # ];
    nameservers = [
      "127.0.0.1"
      "::1"
    ];
    interfaces.ens192 = {
      ipv6.addresses = [
        {
          address = network.ipv6.address;
          prefixLength = 47;
        }
      ];
      ipv4.addresses = [
        {
          address = network.ipv4.address;
          prefixLength = 24;
        }
      ];
    };
    defaultGateway6 = {
      address = network.ipv6.gateway;
      interface = "ens192";
    };
    defaultGateway = {
      address = network.ipv4.gateway;
      interface = "ens192";
    };
    nftables = {
      enable = true;
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [ 443 ];
    };
  };

  services = {
    vnstat.enable = true;
    openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    iperf3 = {
      enable = true;
      openFirewall = true;
    };
    resolved.enable = true;
    dnscrypt-proxy = {
      enable = true;
      settings = {
        listen_addresses = [
          "127.0.0.1:53"
          "[::1]:53"
        ];

        http3 = true;
        # ipv4_servers = false;
        ipv6_servers = true;
        block_ipv6 = false;
        require_dnssec = true;
        require_nolog = true;
        require_nofilter = true;
        # skip_incompatible = true;

        # cache_size = 4096;
        cache_min_ttl = 3600; # Default: 2400
        # cache_max_ttl = 86400;
        # cache_neg_min_ttl = 60;
        # cache_neg_max_ttl = 600;

        sources.public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          ];
          cache_file = "/var/lib/dnscrypt-proxy/public-resolvers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        };

        # Optional: choose exact upstreams from the resolver list.
        # server_names = [ "cloudflare" "quad9-dnscrypt-ip4-filter-pri" ];
      };
    };
  };

  # security = {
  #   acme = {
  #     acceptTerms = true;
  #     defaults = {
  #       dnsProvider = "duckdns";
  #       email = "rickbatra0z@gmail.com";
  #       credentialFiles = {
  #         "DUCKDNS_TOKEN_FILE" = "/root/abcde";
  #       };
  #     };
  #   };
  # };
}