{ pkgs, ... }:
let
  redmibook-acpi-override = pkgs.callPackage ./redmibook-acpi-override.nix {
    filename = "dsdt.aml";
    hash = "sha256-ujKDPKm/6H/atjqDXxbkTcIQbmua3ABxhdNZSfzqWag=";
  };
in
{
  boot.initrd.prepend = [ "${redmibook-acpi-override}" ];

  # boot.kernelParams = [ "mem_sleep_default=deep" ];
  # Optional, for debugging ACPI override load messages:
  # boot.kernelParams = [
  #   "acpi.debug_level=0x2"
  #   "acpi.debug_layer=0xFFFFFFFF"
  # ];
}
