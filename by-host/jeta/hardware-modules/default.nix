{ ... }:
{
  imports = [
    ./pstate.nix
    ./zenpower.nix
    ./redmibook-wmi
    ./acpi-patch
    # ./amdgpu-patch
    ./facter
  ];
}
