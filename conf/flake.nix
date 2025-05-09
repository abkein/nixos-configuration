{
  description = "My NixOS configuration with integrated home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ayugram-desktop = {
      # submodules = true;
      url = "github:ndfined-crp/ayugram-desktop";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "";
    };

    nix4vscode = {
      url = "github:nix-community/nix4vscode";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.darwin.follows = "";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
  };

  outputs = { self, nixpkgs, home-manager, ayugram-desktop, nix-vscode-extensions, nix4vscode, agenix, nur, anyrun, sops-nix, ... }@inputs: {
    nixosConfigurations.jeta = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        agenix.nixosModules.default
        nur.modules.nixos.default
        sops-nix.nixosModules.sops
        {
          imports = [
            home-manager.nixosModules.home-manager
          ];
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            sharedModules = [
              sops-nix.homeManagerModules.sops
            ];
            users.kein = import ./home-manager.nix;
            extraSpecialArgs = {
              inherit inputs;
            };
          };
        }
      ];
      specialArgs = { inherit inputs; };
    };
  };
}