{ config, ... }: {
  programs.corefreq = {
    enable = true;
    package = config.boot.kernelPackages.callPackage ./corefreq.nix { };
  };
}
