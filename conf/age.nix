{ lib }:
let mksec = name: { ${name} = { file = ./secrets/${name}.age; }; };
in {
  identityPaths = [ "/root/key" ];
  secrets = lib.mkMerge [
    { }
    (mksec "xray_generic_address")
    (mksec "xray_generic_ID")
    (mksec "xray_generic_ServerName")
    (mksec "xray_yun_address")
    (mksec "xray_yun_ID")
    (mksec "xray_yun_ShortID")
    (mksec "ssh_fisher_hostname")
    (mksec "ssh_weasel_hostname")
    (mksec "ssh_yun_hostname")
  ];
}
