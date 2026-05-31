{ ... }:
{
  hardware.facter = {
    enable = false;
    reportPath = ./facter.json;
  };
}
