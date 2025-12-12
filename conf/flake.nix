{
  description = "My NixOS configuration with integrated home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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

    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
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

  outputs = { self, nixpkgs, flake-utils, home-manager, ayugram-desktop, nix-vscode-extensions, nix4vscode, agenix, agenix-rekey, nur, anyrun, sops-nix, ... }@inputs:
  {
    nixosConfigurations.jeta = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        # agenix.nixosModules.default
        nur.modules.nixos.default
        sops-nix.nixosModules.sops
        agenix.nixosModules.default
        agenix-rekey.nixosModules.default
        {
          nixpkgs =
          {
            config = {
              allowUnfree = true;
              permittedInsecurePackages = [
                "python3.12-ecdsa-0.19.1"
              ];
            };
            overlays = [
              nix4vscode.overlays.forVscode
              nur.overlays.default
              agenix-rekey.overlays.default
              (import ./overlays/pypackages.nix)
            ];
          };
          imports = [
            home-manager.nixosModules.home-manager
          ];
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "hm-backup";
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
    agenix-rekey = agenix-rekey.configure {
      userFlake = self;
      nixosConfigurations = self.nixosConfigurations;
    };
  }
  //
  flake-utils.lib.eachDefaultSystem ( system:
    let
      pkgs = import nixpkgs { inherit system; };
      python = pkgs.python3;
    in
    {
      packages = {
        pyalex = import ./pkgs/pyalex.nix { pkgs=pkgs; python3Packages=python.pkgs; };
        crossrefapi = import ./pkgs/crossrefapi.nix { pkgs=pkgs; python3Packages=python.pkgs; };
      };

      devShells = rec {
        default = basePython;

        basePython = pkgs.mkShell {
          buildInputs = with pkgs; [
            # python
            pkg-config
            meson
            ninja
            gfortran14
            # stdenv.cc.cc
          ];
        };

        basePythonInteractive = pkgs.mkShell {
          inputsFrom = [ basePython ];
          buildInputs = [
            (python.withPackages (ps: with ps; [
              ipykernel
              pip
              bash_kernel
              ipython
              ipykernel
              jupyter
              jupyterlab
              notebook
              pyzmq
              numpy
              pandas
              scipy
              requests
              matplotlib
            ]))
          ];
        };

        "project-monography" = pkgs.mkShell {
          inputsFrom = [ basePythonInteractive ];
          buildInputs = [
            (python.withPackages (ps: [
              self.packages.${system}.pyalex
              self.packages.${system}.crossrefapi
            ]))
          ];
        };
      };

      # # `nix flake check` entry points (fast CI-like checks)
      # checks.imports = pkgs.runCommand "imports" { } ''
      #   ${pkgs.python312}/bin/python -c "import crossrefapi; print(crossrefapi.__name__)"
      #   touch $out
      # '';
    }
  );
}
