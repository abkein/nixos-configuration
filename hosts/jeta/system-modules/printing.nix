{ pkgs, ... }: {
  # Printing
  services = {
    ipp-usb.enable = true;
    printing = {
      enable = true;
      # tempDir = "/tmp/cups";
      browsing = true;
      logLevel = "debug";
      # cups-pdf.enable = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
        # hplipWithPlugin
      ];
    };
  };

  programs.system-config-printer.enable = true;
  environment.systemPackages = with pkgs; [
    simple-scan
    naps2
  ];

  # Scanning
  hardware = {
    sane = {
      enable = true;
      # netConf = "192.168.0.71";
      openFirewall = true;
      extraBackends = with pkgs; [
        # hplipWithPlugin
        sane-airscan
      ];
    };
  };
}
