{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Printing
  services = {
    colord.enable = true;
    ipp-usb.enable = true;
    printing = {
      enable = true;
      browsing = true;
      # logLevel = "debug";
      extraConf = lib.mkForce ''
        DefaultAuthType Basic

        <Location />
          Order allow,deny
          ${config.services.printing.allowFrom}
        </Location>

        <Location /admin>
          Order allow,deny
          ${config.services.printing.allowFrom}
        </Location>

        <Location /admin/conf>
          AuthType Basic
          Require user @SYSTEM
          Order allow,deny
          ${config.services.printing.allowFrom}
        </Location>

        <Policy default>
          JobPrivateAccess default
          JobPrivateValues default
          SubscriptionPrivateAccess default
          SubscriptionPrivateValues default

          <Limit Create-Job Print-Job Print-URI Validate-Job>
            Order deny,allow
          </Limit>

          <Limit Send-Document Send-URI Hold-Job Release-Job Restart-Job Purge-Jobs Set-Job-Attributes Create-Job-Subscription Renew-Subscription Cancel-Subscription Get-Notifications Reprocess-Job Cancel-Current-Job Suspend-Current-Job Resume-Job Cancel-My-Jobs Close-Job CUPS-Move-Job CUPS-Get-Document>
            Require user @OWNER @SYSTEM
            Order deny,allow
          </Limit>

          <Limit Pause-Printer Resume-Printer Set-Printer-Attributes Enable-Printer Disable-Printer Pause-Printer-After-Current-Job Hold-New-Jobs Release-Held-New-Jobs Deactivate-Printer Activate-Printer Restart-Printer Shutdown-Printer Startup-Printer Promote-Job Schedule-Job-After Cancel-Jobs CUPS-Add-Printer CUPS-Delete-Printer CUPS-Add-Class CUPS-Delete-Class CUPS-Accept-Jobs CUPS-Reject-Jobs CUPS-Set-Default>
            AuthType Basic
            Require user @SYSTEM
            Order deny,allow
          </Limit>

          <Limit Cancel-Job CUPS-Authenticate-Job>
            Require user @OWNER @SYSTEM
            Order deny,allow
          </Limit>

          <Limit All>
            Order deny,allow
          </Limit>
        </Policy>
      '';
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
