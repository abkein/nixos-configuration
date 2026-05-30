{
  pkgs,
  cfg,
  ...
}:
{
  networking = {
    hostName = cfg.hostname;
    nameservers = [
      "127.0.0.1"
      "::1"
    ];
    networkmanager = {
      enable = true;
      wifi = {
        # powersave = false;
        backend = "iwd";
      };
      plugins = with pkgs; [
        networkmanager-openvpn
        networkmanager-ssh
      ];
      dns = "none";
      # dhcp = "dhcpd";
    };
    # modemmanager.enable = true;
    # proxy =
    #   let
    #     httpp = "http://127.0.0.1:1081";
    #     httpsp = "http://127.0.0.1:1081";
    #   in
    #   {
    #     # default = "http://user:password@proxy:port/";
    #     default = httpp;
    #     httpProxy = httpp;
    #     httpsProxy = httpsp;
    #     noProxy = "127.0.0.1,localhost,internal.domain";
    #   };
    nftables = {
      enable = true;
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [ 1716 ];
      allowedUDPPorts = [ 1716 ];
    };
  };

  # systemd.services.nix-daemon.serviceConfig.Environment = [
  #   "http_proxy=http://127.0.0.1:1081"
  #   "https_proxy=http://127.0.0.1:1081"
  #   "no_proxy=localhost,127.0.0.1,::1"
  #   "HTTP_PROXY=http://127.0.0.1:1081"
  #   "HTTPS_PROXY=http://127.0.0.1:1081"
  #   "NO_PROXY=localhost,127.0.0.1,::1"
  # ];

  services = {
    vnstat.enable = true;
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
}
