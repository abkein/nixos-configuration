{ cfg, ... }: {
  networking = {
    hostName = cfg.hostname;
    nameservers = [
      "127.0.0.1"
      "::1"
    ];
    nftables = {
      enable = true;
    };
    firewall = {
      enable = true;
    };
  };

  services = {
    vnstat.enable = true;
    # resolved.enable = true;
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

  programs = {
    traceroute.enable = true;
  };
}
