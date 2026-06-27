{
  description = "My NixOS configuration with integrated home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # nixpkgs.url = "git+file:///home/kein/repos/nixpkgs?rev=279a3747bfd34ed75bb864d190d2ada5afa99bc9";
    # nixpkgs.url = "github:SandaruKasa/nixpkgs/14403d56305e7592b7c9f7f08ae06439bdffd466";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    systems.url = "github:nix-systems/default";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # nix-vscode-extensions = {
    #   url = "github:nix-community/nix-vscode-extensions";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   # inputs.flake-utils.follows = "flake-utils";
    # };

    nix4vscode = {
      url = "github:nix-community/nix4vscode";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        darwin.follows = "";
        systems.follows = "systems";
        home-manager.follows = "home-manager";
      };
    };

    # flake-compat.url = "github:edolstra/flake-compat";

    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # pre-commit-hooks = {
    #   url = "github:cachix/pre-commit-hooks.nix";
    #   inputs = {
    #     nixpkgs.follows = "nixpkgs";
    #     gitignore.follows = "gitignore";
    #     flake-compat.follows = "flake-compat";
    #   };
    # };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # agenix-rekey = {
    #   url = "github:oddlama/agenix-rekey";
    #   inputs = {
    #     nixpkgs.follows = "nixpkgs";
    #     flake-parts.follows = "flake-parts";
    #     pre-commit-hooks.follows = "pre-commit-hooks";
    #     treefmt-nix.follows = "treefmt-nix";
    #   };
    # };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        systems.follows = "systems";
        nur.follows = "nur";
      };
    };

    # anyrun = {
    #   url = "github:anyrun-org/anyrun";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # sops-nix = {
    #   url = "github:Mic92/sops-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/beta";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    # git-hooks = {
    #   url = "github:cachix/git-hooks.nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    ayugram-desktop = {
      url = "github:ndfined-crp/ayugram-desktop";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        # flake-parts.follows = "flake-parts";
        # git-hooks.follows = "git-hooks";
      };
      # type = "git";
      # submodules = true;
      # url = "https://github.com/ndfined-crp/ayugram-desktop/";
    };

    codex-cli = {
      url = "github:sadjow/codex-cli-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      lib = nixpkgs.lib;
      mylib = import ./mylib { inherit lib; };
      useAgenixRekey = false;
      secrets = "secrets/agenix/encrypted";
      _ipkgs =
        system:
        with inputs;
        {
          agenix = agenix.packages.${system}.default;
          codex-cli = codex-cli.packages.${system}.default;
          # claude-code = claude-code.packages.${system}.default;
          ayugram-desktop = ayugram-desktop.packages.${system}.ayugram-desktop;
          # anyrun-pkgs = anyrun.packages.${system}.default;
        }
        // (lib.optionalAttrs useAgenixRekey { agenix-rekey = agenix-rekey.packages.${system}.default; });
    in
    {
      overlays.default = import ./pkgs/overlay.nix;
      nixosConfigurations = {
        jeta =
          let
            cfg = rec {
              system = "x86_64-linux";
              hostname = "jeta";
              username = "kein";
              userhome = "/home/${username}";
              uid = 1000;
              xdg.runtimeDir = "\${XDG_RUNTIME_DIR:-/run/user/${toString uid}}";
              flakepath = "${userhome}/nixos-configuration";
              inherit secrets useAgenixRekey;
            };
            ipkgs = _ipkgs cfg.system;
            specialArgs = { inherit ipkgs cfg mylib; };
          in
          lib.nixosSystem {
            inherit (cfg) system;
            inherit specialArgs;
            modules =
              (
                with inputs;
                [
                  nur.modules.nixos.default
                  home-manager.nixosModules.home-manager
                  disko.nixosModules.disko
                  agenix.nixosModules.default
                  stylix.nixosModules.stylix
                ]
                ++ (lib.optionals cfg.useAgenixRekey [ agenix-rekey.nixosModules.default ])
              )
              ++ [
                ./hosts/jeta
                {
                  nixpkgs = {
                    config = {
                      allowUnfree = true;
                      # rocmSupport = true;
                      warnUndeclaredOptions = true;
                      permittedInsecurePackages = [
                        "pypy2.7-setuptools-44.0.0"
                        "pypy2.7-pip-20.3.4"
                      ];
                    };
                    overlays =
                      (with inputs; [
                        nix4vscode.overlays.forVscode
                        nur.overlays.default
                        # nix-vscode-extensions.overlays.default
                      ])
                      ++ [
                        self.overlays.default
                        # (import ./overlays/pypackages.nix)
                        # (import ./overlays/generic.nix)
                      ];
                  };
                  environment.systemPackages = with ipkgs; [ (if cfg.useAgenixRekey then agenix-rekey else agenix) ];
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    backupFileExtension = "hm-backup";
                    overwriteBackup = true;
                    sharedModules = with inputs; [
                      agenix.homeManagerModules.default
                      zen-browser.homeModules.beta
                      # stylix.homeModules.stylix
                    ];
                    users = {
                      "${cfg.username}" = ./hosts/jeta/home-manager.nix;
                    };
                    extraSpecialArgs = specialArgs;
                  };
                }
              ];
          };
        yun =
          let
            cfg = rec {
              system = "x86_64-linux";
              hostname = "yun";
              username = "kein";
              userhome = "/home/${username}";
              uid = 1000;
              xdg.runtimeDir = "\${XDG_RUNTIME_DIR:-/run/user/${toString uid}}";
              flakepath = "${userhome}/nixos-configuration";
              inherit secrets useAgenixRekey;
            };
            ipkgs = _ipkgs cfg.system;
            specialArgs = { inherit ipkgs cfg; };
          in
          lib.nixosSystem {
            inherit (cfg) system;
            inherit specialArgs;
            modules =
              (
                with inputs;
                [
                  home-manager.nixosModules.home-manager
                  disko.nixosModules.disko
                  agenix.nixosModules.default
                ]
                ++ (lib.optionals cfg.useAgenixRekey [ agenix-rekey.nixosModules.default ])
              )
              ++ [
                ./hosts/yun
                {
                  # nixpkgs = { };
                  environment.systemPackages = with ipkgs; [ (if cfg.useAgenixRekey then agenix-rekey else agenix) ];
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    backupFileExtension = "hm-backup";
                    overwriteBackup = true;
                    sharedModules = with inputs; [ agenix.homeManagerModules.default ];
                    users = {
                      "${cfg.username}" = ./hosts/yun/home-manager.nix;
                    };
                    extraSpecialArgs = specialArgs;
                  };
                }
              ];
          };
      };
      # devShells.${system}.default = nixpkgs.mkShell {};
    }
    // (lib.optionalAttrs useAgenixRekey {
      agenix-rekey = inputs.agenix-rekey.configure {
        userFlake = self;
        nixosConfigurations = self.nixosConfigurations;
      };
    })
    // (inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        # pkgs = nixpkgs.legacyPackages.${system};
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        };
        treefmtEval = (inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix).config.build;
      in
      {
        # for `nix fmt`
        formatter = treefmtEval.wrapper;
        # for `nix flake check`
        # checks = {
        #   formatting = treefmtEval.check self;
        # };
        packages =
          (lib.foldl' (acc: elem: acc // { ${elem} = pkgs.${elem}; }) { } [
            "keepassxc-proxy-client"
            "pyzotero"
            "jsonc-parser"
            "crossrefapi"
            "lammps-logfile"
            "ast-serialize"
            "librt"
          ])
          // (_ipkgs system)
          // {
            mypy = pkgs.python3Packages.callPackage ./pkgs/mypy.nix { };
          };

        devShells = import ./shells {
          inherit
            nixpkgs
            pkgs
            system
            mylib
            ;
        };
      }
    ));
}
