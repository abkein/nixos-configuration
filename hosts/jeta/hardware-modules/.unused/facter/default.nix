{ ... }: {
  hardware.facter = {
    enable = false;
    reportPath = ./facter.json;
  };
}

# Interesting output

# {
#   boot = {
#     disk = {
#       kernelModules = [ "nvme" ];
#     };
#     graphics = {
#       kernelModules = [ "amdgpu" ];
#     };
#     initrd = {
#       networking = {
#         kernelModules = [
#           "cdc_ncm"
#           "mt7921e"
#         ];
#       };
#     };
#     keyboard = {
#       kernelModules = [ "xhci_pci" ];
#     };
#   };
#   dhcp = {
#     enable = true;
#     interfaces = [
#       "wlan0"
#       "eth0"
#     ];
#   };
#   graphics = {
#     amd = {
#       enable = true;
#     };
#     enable = true;
#   };
# }
