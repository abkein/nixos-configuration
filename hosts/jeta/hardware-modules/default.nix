{ ... }: {
  imports = [
    ./corefreq
    ./pstate.nix
    ./redmibook-wmi
    ./acpi-patch
    # ./zenpower.nix
    # ./amdgpu-patch
    # ./facter
  ];
}
