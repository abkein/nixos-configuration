{ config, ... }: {
  programs.corefreq = {
    enable = false;
    package = config.boot.kernelPackages.callPackage ./corefreq.nix { };
  };
}
