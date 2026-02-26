let
  kein = "age1yubikey1q02n4jegke9g9ntr7kcymns0pjpyqfllnr4k5tesa79az7mau8s2gfsnx92";
  # kein = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKzMEb6MSQOJnLdf3EdsrsPuiRYJ3Weg00/HbJ+3JeVv";
  users = [ kein ];

  # system1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJDyIr/FSz1cJdcoW69R+NrWzwGK/+3gJpqD1t8L2zE";
  # system2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKzxQgondgEYcLpcPdJLrTdNgZ2gznOHCAxMdaceTUT1";
  # systems = [ system1 system2 ];
in
{
  "encrypted/nix-access-tokens.conf.age" = {
    publicKeys = [ kein ];
    armor = true;
  };
  "encrypted/nix-netrc.age" = {
    publicKeys = [ kein ];
    armor = true;
  };
  "encrypted/syncthingPass.age" = {
    publicKeys = [ kein ];
    armor = true;
  };
}