{
  description = "My NixOS configuration with integrated home-manager";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/6c9a78c09ff4d6c21d0319114873508a6ec01655";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

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

    # gitignore = {
    #   url = "github:hercules-ci/gitignore.nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

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
        # IMPORTANT: To ensure compatibility with the latest Firefox version, use nixpkgs-unstable.
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
      useAgenixRekey = false;
      secrets = "secrets/agenix/encrypted";
    in
    {
      nixosConfigurations = {
        jeta =
          let
            cfg = rec {
              system = "x86_64-linux";
              hostname = "jeta";
              username = "kein";
              userhome = "/home/${username}";
              flakepath = "${userhome}/nixos-configuration";
              inherit useAgenixRekey;
              inherit secrets;
            };
            ipkgs =
              let
                system = cfg.system;
              in
              with inputs;
              {
                agenix = agenix.packages.${system}.default;
                codex-cli = codex-cli.packages.${system}.default;
                claude-code = claude-code.packages.${system}.default;
                ayugram-desktop = ayugram-desktop.packages.${system}.ayugram-desktop;
                # anyrun-pkgs = anyrun.packages.${system}.default;
              }
              // (lib.optionalAttrs cfg.useAgenixRekey {
                agenix-rekey = agenix-rekey.packages.${system}.default;
              });
            mylib = import ./mylib.nix lib;
          in
          lib.nixosSystem {
            inherit (cfg) system;
            specialArgs = {
              inherit ipkgs;
              inherit cfg;
              inherit mylib;
            };
            modules =
              (
                with inputs;
                [
                  nur.modules.nixos.default
                  home-manager.nixosModules.home-manager
                  disko.nixosModules.disko
                  agenix.nixosModules.default
                ]
                ++ (lib.optionals cfg.useAgenixRekey [ agenix-rekey.nixosModules.default ])
              )
              ++ [
                ./by-host/jeta
                {
                  nixpkgs = {
                    flake.source = self.outPath;
                    config = {
                      allowUnfree = true;
                    };
                    overlays =
                      (with inputs; [
                        nix4vscode.overlays.forVscode
                        nur.overlays.default
                        # nix-vscode-extensions.overlays.default
                      ])
                      ++ [
                        (import ./overlays/pypackages.nix)
                        (import ./overlays/generic.nix)
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
                    ];
                    users = {
                      "${cfg.username}" = ./by-host/jeta/home-manager.nix;
                    };
                    extraSpecialArgs = {
                      inherit ipkgs;
                      inherit cfg;
                      inherit mylib;
                    };
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
              flakepath = "${userhome}/nixos-configuration";
              inherit useAgenixRekey;
              inherit secrets;
            };
            ipkgs =
              let
                system = cfg.system;
              in
              with inputs;
              {
                agenix = agenix.packages.${system}.default;
              }
              // (lib.optionalAttrs cfg.useAgenixRekey {
                agenix-rekey = agenix-rekey.packages.${system}.default;
              });
          in
          lib.nixosSystem {
            inherit (cfg) system;
            specialArgs = {
              inherit ipkgs;
              inherit cfg;
            };
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
                ./by-host/yun
                {
                  nixpkgs = {
                    flake.source = self.outPath;
                  };
                  environment.systemPackages = with ipkgs; [ (if cfg.useAgenixRekey then agenix-rekey else agenix) ];
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    backupFileExtension = "hm-backup";
                    overwriteBackup = true;
                    sharedModules = with inputs; [
                      agenix.homeManagerModules.default
                    ];
                    users = {
                      "${cfg.username}" = ./by-host/yun/home-manager.nix;
                    };
                    extraSpecialArgs = {
                      inherit ipkgs;
                      inherit cfg;
                    };
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
        pkgs = nixpkgs.legacyPackages.${system};
        treefmtEval = (inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix).config.build;
      in
      {
        # for `nix fmt`
        formatter = treefmtEval.wrapper;
        # for `nix flake check`
        checks = {
          formatting = treefmtEval.check self;
        };
      }
    ));
}
