self: super:
let
  solo1-cli = super.fetchFromGitHub {
    owner = "abkein";
    repo = "solo1-cli";
    rev = "ea8dc795729356eb421db5918b4392316ab90f77";
    hash = "sha256-nJ+2NWpRGyVz2mRNohOBR9DHYoTFjtD+rTTrr2WsY0w=";
  };
in
{
  python3Packages = super.python3Packages.overrideScope (pySelf: pySuper: {
    pyzotero = import ../pkgs/pyzotero.nix { pkgs=self; python3Packages=pySelf; };
    jsonc-parser = import ../pkgs/jsonc-parser.nix { pkgs=self; python3Packages=pySelf; };
    pyalex = import ../pkgs/pyalex.nix { pkgs=self; python3Packages=pySelf; };
    crossrefapi = import ../pkgs/crossrefapi.nix { pkgs=self; python3Packages=pySelf; };
    keepassxc-proxy-client = import ../pkgs/keepassxc-proxy-client.nix { pkgs=self; python3Packages=pySelf; };
    solo1-cli = super.callPackage "${solo1-cli}/solo.nix" {};
  });

  solo1-cli = self.python3Packages.solo1-cli;
  keepassxc-proxy-client = self.python3Packages.keepassxc-proxy-client;
  pyzotero = self.python3Packages.pyzotero;
  jsonc-parser = self.python3Packages.jsonc-parser;
  pyalex = self.python3Packages.pyalex;
  crossrefapi = self.python3Packages.crossrefapi;
}
