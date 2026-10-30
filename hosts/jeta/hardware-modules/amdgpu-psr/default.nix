{ ... }: {
  # Restore the PSR-SU guard lost when AMDGPU switched to the power module.
  # Tested against Linux 7.3; keep PSR1 enabled on the internal panel.
  boot.kernelPatches = [
    {
      name = "amdgpu-psr-su-dsc-guard";
      patch = ./psr-su-dsc-guard.patch;
    }
  ];
}
