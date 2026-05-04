let
  kein = "age1yubikey1q02n4jegke9g9ntr7kcymns0pjpyqfllnr4k5tesa79az7mau8s2gfsnx92";
  home = "age1349d9ags7k4r9tpvzmtmrc4yrt3q2jd6myp2e0cg06tqt87qjp5qzc0nqe";
  root = "age1tn9ljj02mvx0mfkw9fzlv8pjpvqpsv72f0darwytuq0ga2x4m5dq8vxk63";
in
{
  "encrypted/nix-access-tokens.conf.age" = {
    publicKeys = [
      kein
      root
    ];
    armor = true;
  };
  "encrypted/nix-netrc.age" = {
    publicKeys = [
      kein
      root
    ];
    armor = true;
  };
  "encrypted/syncthingPass.age" = {
    publicKeys = [
      kein
      home
    ];
    armor = true;
  };
}
