{
  description = "My NixOS configuration with integrated home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ayugram-desktop = {
      type = "git";
      submodules = true;
      url = "https://github.com/ndfined-crp/ayugram-desktop/";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.flake-utils.follows = "flake-utils";
    };

    nix4vscode = {
      url = "github:nix-community/nix4vscode";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
    };

    # agenix-rekey = {
    #   url = "github:oddlama/agenix-rekey";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      home-manager,
      ayugram-desktop,
      nix-vscode-extensions,
      nix4vscode,
      agenix,
      nur,
      anyrun,
      sops-nix,
      disko,
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
          modules = [
            ./configuration.nix
            ./disko.nix
            nur.modules.nixos.default
            sops-nix.nixosModules.sops
            agenix.nixosModules.default
            # agenix-rekey.nixosModules.default
            home-manager.nixosModules.home-manager
            disko.nixosModules.disko
            {
              nixpkgs = {
                config = {
                  allowUnfree = true;
                  permittedInsecurePackages = [
                    "python3.12-ecdsa-0.19.1"
                  ];
                };
                overlays = [
                  nix4vscode.overlays.forVscode
                  nur.overlays.default
                  # agenix-rekey.overlays.default
                  (import ./overlays/pypackages.nix)
                  (import ./overlays/generic.nix)
                ];
              };
              environment.systemPackages = [ agenix.packages.${system}.default ];
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "hm-backup";
                overwriteBackup = true;
                sharedModules = [
                  sops-nix.homeManagerModules.sops
                  agenix.homeManagerModules.default
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
        modules = [
          disko.nixosModules.disko
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
