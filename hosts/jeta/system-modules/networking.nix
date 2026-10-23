{ config, pkgs, ... }: {
  imports = [ ../../../universal/system-modules/networking.nix ];

  networking = {
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
      # dns = "none";
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
    firewall = {
      allowedTCPPorts = [ 1716 ]; # KDEconnect
      allowedUDPPorts = [ 1716 ]; # KDEconnect
    };
  };

  services = {
    resolved.settings.Resolve.MulticastDNS = false;
    dnscrypt-proxy.settings = {
      monitoring_ui = {
        enabled = true;
        listen_address = "127.0.0.1:8181";
        username = "admin";
        password = "admin";
        tls_certificate = ./dnscrypt.web.crt;
        tls_key = config.age.secrets.dnscrypt-web.path;
        enable_query_log = true;
        privacy_level = 0;
      };
      cloaking_rules = pkgs.writeText "dns-cloaking-rules" ''
        =localhost 127.0.0.1
        =localhost ::1
        =dnscrypt.home.arpa 127.0.0.1
        =dnscrypt.home.arpa ::1
        =doh.home.arpa 127.0.0.1
        =doh.home.arpa ::1
        =immich.home.arpa 127.0.0.1
        =immich.home.arpa ::1
      '';

      cloak_ttl = 60;
      local_doh = {
        listen_addresses = [
          "127.0.0.1:3000"
          "[::1]:3000"
        ];
        path = "/dns-query";
        cert_file = ./dnscrypt.doh.crt;
        cert_key_file = config.age.secrets.dnscrypt-doh.path;
      };
    };
  };
}
