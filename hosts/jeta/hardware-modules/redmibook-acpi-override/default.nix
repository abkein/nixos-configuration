{ pkgs, ... }:
let
  redmibook-acpi-override = pkgs.callPackage ./redmibook-acpi-override.nix {
    filename = "dsdt.aml";
    hash = "sha256-ujKDPKm/6H/atjqDXxbkTcIQbmua3ABxhdNZSfzqWag=";
  };
in
{
  boot.initrd.prepend = [ "${redmibook-acpi-override}" ];

  boot.kernelParams = [
    "mem_sleep_default=deep"
  ]
  ++ [
    # "no_console_suspend"
    # "ignore_loglevel"
    "pm_debug_messages"
    "loglevel=8"
    "acpi.debug_level=0x2"
    "acpi.debug_layer=0xFFFFFFFF"
  ];
  # ++ [ "amdgpu.sg_display=0" ];

}
