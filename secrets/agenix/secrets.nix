let
  kein = "age1yubikey1q02n4jegke9g9ntr7kcymns0pjpyqfllnr4k5tesa79az7mau8s2gfsnx92";
  home = "age1349d9ags7k4r9tpvzmtmrc4yrt3q2jd6myp2e0cg06tqt87qjp5qzc0nqe";
  jeta = "age1tn9ljj02mvx0mfkw9fzlv8pjpvqpsv72f0darwytuq0ga2x4m5dq8vxk63";
  yun = "age17aearyq69n484l270x0hh8z7uczpyz57v972xfrwrtcayyfyvaqsrd3s66";
in
{
  "encrypted/nix-access-tokens.conf.age" = {
    publicKeys = [
      kein
      jeta
      yun
    ];
    armor = true;
  };
  "encrypted/nix-netrc.age" = {
    publicKeys = [
      kein
      jeta
      yun
    ];
    armor = true;
  };
  "encrypted/syncthingPass.age" = {
    publicKeys = [
      kein
      home
      jeta
    ];
    armor = true;
  };
}
