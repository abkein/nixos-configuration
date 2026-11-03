{ ... }: {
  # pick a kernel to patch
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # apply local patch to the kernel tree
  boot.kernelPatches = [
    {
      name = "amdgpu-VRR-MST-patch";
      patch = ./amdgpu_dm.c.diff;
    }
  ];
}
