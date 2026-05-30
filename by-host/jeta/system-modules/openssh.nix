{...}:
{
  services.openssh = {
    enable = true;
    listenAddresses = [
      {
        addr = "[fdcd:59e2:3ff3:0:263c:ed4a:7037:f1bb]";
        port = 22;
      }
      {
        addr = "[fdcd:59e2:3ff3:0:ca10:8ba0:9523:f762]";
        port = 22;
      }
      {
        addr = "[2a03:d000:4191:485c:4698:359a:8e34:30ae]";
        port = 22;
      }
      {
        addr = "[2a03:d000:4191:485c:1298:9f52:af8b:b03]";
        port = 22;
      }
      {
        addr = "[fe80::33c3:37a2:d653:5fdf]";
        port = 22;
      }
    ];
  };
}