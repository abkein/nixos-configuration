{ ... }:
{
  imports = [
    ./pstate.nix
    ./zenpower.nix
    ./redmibook-wmi.nix
    ./acpi-patch.nix
    # ./amdgpu-patch.nix
    ./facter
  ];
}
