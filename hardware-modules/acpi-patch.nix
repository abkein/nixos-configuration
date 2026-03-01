# configuration.nix (or a module)
{ config, pkgs, lib, ... }:

let
  acpiOverride = pkgs.runCommand "acpi-override.cpio" {
    nativeBuildInputs = [
      pkgs.acpica-tools   # iasl
      pkgs.cpio
      pkgs.gnupatch
    ];
    srcAml = ./acpi-patch/dsdt.aml;
    srcDiff = ./acpi-patch/dsdt.dsl.diff;
  } ''
    set -euo pipefail
    mkdir work
    cd work

    cp "$srcAml" dsdt.aml
    cp "$srcDiff" dsdt.dsl.diff

    # Decompile the table
    iasl -d dsdt.aml
    rm dsdt.aml

    patch -p0 < dsdt.dsl.diff

    # IMPORTANT: bump OEM Revision in DefinitionBlock(...) in dsdt.dsl
    # so Linux prefers your override over firmware table

    # Compile to AML
    iasl -sa dsdt.dsl
    # iasl dsdt.dsl

    # Build the required initrd layout
    mkdir -p kernel/firmware/acpi
    cp dsdt.aml kernel/firmware/acpi/

    # Create UNCOMPRESSED cpio in "newc" format
    (find kernel | cpio -H newc --create) > "$out"
  '';
in
{
  boot.initrd.prepend = [ "${acpiOverride}" ];

  # boot.kernelParams = [ "mem_sleep_default=deep" ];
  # Optional, for debugging ACPI override load messages:
  # boot.kernelParams = [
  #   "acpi.debug_level=0x2"
  #   "acpi.debug_layer=0xFFFFFFFF"
  # ];
}