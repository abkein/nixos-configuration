{
  description = "My NixOS configuration with integrated home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/6c9a78c09ff4d6c21d0319114873508a6ec01655";

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

    # agenix-rekey = {
    #   url = "github:oddlama/agenix-rekey";
    #   inputs.nixpkgs.follows = "nixpkgs";
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

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ayugram-desktop = {
      url = "github:ndfined-crp/ayugram-desktop";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "git-hooks";
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
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        jeta =
          let
            cfg = rec {
              system = "x86_64-linux";
              username = "kein";
              userhome = "/home/kein";
              flakepath = "${userhome}/nixos-configuration";
              hostname = "jeta";
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
              };
          in
          nixpkgs.lib.nixosSystem {
            inherit (cfg) system;
            specialArgs = {
              inherit ipkgs;
              inherit cfg;
            };
            modules =
              (with inputs; [
                nur.modules.nixos.default
                agenix.nixosModules.default
                home-manager.nixosModules.home-manager
                disko.nixosModules.disko
                # sops-nix.nixosModules.sops
                # agenix-rekey.nixosModules.default
              ])
              ++ [
                ./configuration.nix
                ./disko.nix
                {
                  nixpkgs = {
                    hostPlatform = cfg.system;
                    config = {
                      allowUnfree = true;
                      permittedInsecurePackages = [
                        "python3.12-ecdsa-0.19.1"
                      ];
                    };
                    overlays =
                      (with inputs; [
                        nix4vscode.overlays.forVscode
                        nur.overlays.default
                        # nix-vscode-extensions.overlays.default
                        # agenix-rekey.overlays.default
                      ])
                      ++ [
                        (import ./overlays/pypackages.nix)
                        (import ./overlays/generic.nix)
                      ];
                  };
                  environment.systemPackages = with ipkgs; [ agenix ];
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    backupFileExtension = "hm-backup";
                    overwriteBackup = true;
                    sharedModules = with inputs; [
                      agenix.homeManagerModules.default
                      zen-browser.homeModules.beta
                      # sops-nix.homeManagerModules.sops
                    ];
                    users = {
                      "${cfg.username}" = ./home-manager.nix;
                    };
                    extraSpecialArgs = {
                      inherit ipkgs;
                      inherit cfg;
                    };
                  };
                }
              ];
          };
        yun =
          let
            cfg = {
              system = "x86_64-linux";
            };
          in
          nixpkgs.lib.nixosSystem {
            system = cfg.system;
            modules =
              (with inputs; [
                disko.nixosModules.disko
              ])
              ++ [
                {
                  nixpkgs.hostPlatform = cfg.system;
                }
                ./yun/configuration.nix
                ./yun/hardware-configuration.nix
                ./yun/disko.nix
              ];
          };
        # agenix-rekey = agenix-rekey.configure {
        #   userFlake = self;
        #   nixosConfigurations = self.nixosConfigurations;
        # };
        # devShells.${system}.default = nixpkgs.mkShell {};
      };
    };
}
