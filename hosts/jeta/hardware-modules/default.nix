{ ... }: {
  imports = [
    ./amdgpu-psr
    ./corefreq
    ./pstate.nix
    ./redmibook-acpi-override
  ];
}
