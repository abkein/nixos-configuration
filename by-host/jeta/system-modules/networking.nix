{ pkgs, ... }:
{
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
    firewall = {
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
}
