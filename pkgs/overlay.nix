final: prev:
let
  solo1-cli = prev.fetchFromGitHub {
    owner = "abkein";
    repo = "solo1-cli";
    rev = "ea8dc795729356eb421db5918b4392316ab90f77";
    hash = "sha256-nJ+2NWpRGyVz2mRNohOBR9DHYoTFjtD+rTTrr2WsY0w=";
  };
in
{
  python3Packages = prev.python3Packages.overrideScope (
    pySelf: pySuper: {
      # pyzotero = import ./pyzotero.nix { pkgs=self; python3Packages=pySelf; };  # now in nixpkgs
      jsonc-parser = pySelf.callPackage ./jsonc-parser.nix { };
      pyalex = pySelf.callPackage ./pyalex.nix { };
      crossrefapi = pySelf.callPackage ./crossrefapi.nix { };
      keepassxc-proxy-client = pySelf.callPackage ./keepassxc-proxy-client.nix { };
      solo1-cli = pySelf.callPackage "${solo1-cli}/solo.nix" { };
      lammps-logfile = pySelf.callPackage ./lammps-logfile.nix { };
      # ast-serialize = pySelf.callPackage ./ast-serialize.nix { };
      # librt = pySelf.callPackage ./librt.nix { };
    }
  );

  # pyalex = self.python3Packages.pyalex;
  solo1-cli = final.python3Packages.solo1-cli;
  keepassxc-proxy-client = final.python3Packages.keepassxc-proxy-client;
  pyzotero = final.python3Packages.pyzotero;
  jsonc-parser = final.python3Packages.jsonc-parser;
  crossrefapi = final.python3Packages.crossrefapi;
  # mypy = self.python3Packages.callPackage ./mypy.nix { };
  lammps-logfile = final.python3Packages.lammps-logfile;
  # ast-serialize = self.python3Packages.ast-serialize;
  # librt = self.python3Packages.librt;

  vscode-extensions.vscode-clang-tidy = import ./vscode-clang-tidy/vscode-clang-tidy.nix final;
  zotero-addons = final.callPackage ./zotero-addons.nix { };
  ibus-engines = prev.ibus-engines // {
    typing-booster-unwrapped = final.callPackage ./ibus-typing-booster { };
  };
  vimix-icon-theme = final.callPackage ./vimix-icon-theme.nix { };
}
