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
  wayprompt =
    let
      version = "0.1.2-mzte.2";
      src = final.fetchFromGitea {
        domain = "git.mzte.de";
        owner = "LordMZTE";
        repo = "wayprompt";
        tag = "v${version}";
        hash = "sha256-uVkeLJgvdc6c7xmNUdWlUS1f3fx8cCIV/raw2prP4O4=";
      };
      deps = final.zig_0_16.fetchDeps {
        inherit version src;
        pname = "wayprompt";
        hash = "sha256-j1SrpUFgrtcv2pf43ZxRo3poYtMDQnWS3vmKkU5trE0=";
      };
    in
    prev.wayprompt.overrideAttrs {
      inherit version src;

      nativeBuildInputs = with final; [
        zig_0_16
        pkg-config
        wayland
        wayland-scanner
        scdoc
      ];

      zigBuildFlags = [ ];

      preBuild = ''
        ln -sf "${deps}" "$ZIG_GLOBAL_CACHE_DIR/p"
      '';
    };
  python3Packages = prev.python3Packages.overrideScope (
    pySelf: pySuper: {
      # pyzotero = import ./pyzotero.nix { pkgs=self; python3Packages=pySelf; };  # now in nixpkgs
      jsonc-parser = pySelf.callPackage ./jsonc-parser.nix { };
      pyalex = pySelf.callPackage ./pyalex.nix { };
      crossrefapi = pySelf.callPackage ./crossrefapi.nix { };
      keepassxc-proxy-client = pySelf.callPackage ./keepassxc-proxy-client.nix { };
      solo1-cli = pySelf.callPackage "${solo1-cli}/solo.nix" { };
      lammps-logfile = pySelf.callPackage ./lammps-logfile.nix { };
      pyemf3 = pySelf.callPackage ./pyemf3.nix { };
      # ast-serialize = pySelf.callPackage ./ast-serialize.nix { };
      # librt = pySelf.callPackage ./librt.nix { };
    }
  );

  # kdePackages = prev.kdePackages.overrideScope (kfinal: kprev: {
  #   dolphin = prev.symlinkJoin {
  #     name = "dolphin-wrapped";
  #     paths = [ kprev.dolphin kprev.dolphin.dev ];
  #     nativeBuildInputs = [ prev.makeWrapper ];
  #     postBuild = ''
  #       rm $out/bin/dolphin
  #       makeWrapper ${kprev.dolphin}/bin/dolphin $out/bin/dolphin \
  #         --set XDG_CONFIG_DIRS "${kprev.kservice}/etc/xdg:$XDG_CONFIG_DIRS" \
  #         --run "${kprev.kservice}/bin/kbuildsycoca6 --noincremental ${kprev.kservice}/etc/xdg/menus/applications.menu"
  #     '';
  #     passthru = (kprev.dolphin.passthru or {}) // { dev = kprev.dolphin.dev; };
  #   };
  # });

  # pyalex = self.python3Packages.pyalex;
  solo1-cli = final.python3Packages.solo1-cli;
  keepassxc-proxy-client = final.python3Packages.keepassxc-proxy-client;
  pyzotero = final.python3Packages.pyzotero;
  jsonc-parser = final.python3Packages.jsonc-parser;
  crossrefapi = final.python3Packages.crossrefapi;
  # mypy = self.python3Packages.callPackage ./mypy.nix { };
  lammps-logfile = final.python3Packages.lammps-logfile;
  pyemf3 = final.python3Packages.pyemf3;
  # ast-serialize = self.python3Packages.ast-serialize;
  # librt = self.python3Packages.librt;

  veusz = prev.callPackage ./veusz { };

  vscode-extensions.vscode-clang-tidy = import ./vscode-clang-tidy/vscode-clang-tidy.nix final;
  zotero-addons = final.callPackage ./zotero-addons.nix { };
  micro-plugins = final.callPackage ./micro-plugins.nix { };
  ibus-engines = prev.ibus-engines // {
    typing-booster-unwrapped = final.callPackage ./ibus-typing-booster { };
  };
  vimix-icon-theme = final.callPackage ./vimix-icon-theme.nix { };
}
