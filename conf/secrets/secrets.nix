let
  system =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKCbM6U1uHMTvtvg7DeZFisXf1KlRvaPkUJdCKMu+T8M";
  systems = [ system ];
in
{
  "xray_generic_address.age".publicKeys = systems;
  "xray_generic_ID.age".publicKeys = systems;
  "xray_generic_ServerName.age".publicKeys = systems;
  "xray_yun_address.age".publicKeys = systems;
  "xray_yun_ID.age".publicKeys = systems;
  "xray_yun_ShortID.age".publicKeys = systems;
  "ssh_fisher_hostname.age".publicKeys = systems;
  "ssh_weasel_hostname.age".publicKeys = systems;
  "ssh_yun_hostname.age".publicKeys = systems;
}
