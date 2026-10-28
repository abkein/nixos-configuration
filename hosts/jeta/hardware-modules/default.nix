{ ... }: {
  imports = [
    ./corefreq
    ./pstate.nix
    ./redmibook-wmi
    ./redmibook-acpi-override
    # ./zenpower.nix
    # ./amdgpu-patch
    # ./facter
  ];
}
