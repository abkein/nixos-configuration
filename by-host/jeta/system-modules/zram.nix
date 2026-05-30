{
  boot.kernel.sysctl."vm.swappiness" = 100;

  zramSwap = {
    enable = true;
    algorithm = "lz4";
    memoryPercent = 50;
    priority = 100;
  };
}
