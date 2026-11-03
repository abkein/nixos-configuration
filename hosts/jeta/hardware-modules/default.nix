{ ... }: {
  imports = [
    ./amdgpu-psr
    ./corefreq
    ./pstate.nix
    ./redmibook-acpi-override
    # ./redmibook-wmi
    # ./zenpower.nix
    # ./amdgpu-patch
    # ./facter
  ];
}
