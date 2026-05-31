{ pkgs, ... }:
{
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
}
