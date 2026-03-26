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
      url = "github:abkein/ayugram-desktop/ad9096991e9dce9a2e2454a2fc6e0c6d7335b486";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "git-hooks";
      };
      # type = "git";
      # submodules = true;
      # url = "https://github.com/ndfined-crp/ayugram-desktop/";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      cfg = rec {
        username = "kein";
        userhome = "/home/kein";
        flakepath = "${userhome}/nixos-configuration";
        hostname = "jeta";
      };
    in
    {
      nixosConfigurations = {
        jeta = nixpkgs.lib.nixosSystem rec {
          inherit system;
          specialArgs = {
            inherit inputs;
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
                environment.systemPackages = [ inputs.agenix.packages.${system}.default ];
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
                    inherit inputs;
                    inherit cfg;
                  };
                };
              }
            ];
        };
        yun = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules =
            (with inputs; [
              disko.nixosModules.disko
            ])
            ++ [
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
