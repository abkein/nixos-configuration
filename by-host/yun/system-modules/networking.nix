{ ... }:
let
  network-creds = import ../shadow/network.nix;
in
{
  imports = [
    ../../../universal/system-modules/networking.nix
  ];

  networking = {
    useDHCP = false;
    interfaces.ens192 = {
      ipv6.addresses = [
        {
          address = network-creds.ipv6.address;
          prefixLength = 47;
        }
      ];
      ipv4.addresses = [
        {
          address = network-creds.ipv4.address;
          prefixLength = 24;
        }
      ];
    };
    defaultGateway6 = {
      address = network-creds.ipv6.gateway;
      interface = "ens192";
    };
    defaultGateway = {
      address = network-creds.ipv4.gateway;
      interface = "ens192";
    };
    firewall = {
      allowedTCPPorts = [ 443 ];
    };
  };

  services = {
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
