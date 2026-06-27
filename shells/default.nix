{
  nixpkgs,
  pkgs,
  lib ? nixpkgs.lib,
  system,
  mylib,
}:
let
  shell-tools = import ./shell-tools.nix { inherit nixpkgs system mylib; };
  shells = import ./shell-collection.nix { inherit lib shell-tools; };

  mkCppShellWithPython = shells.mkCppShell.extend shells.modules.pythonBase;
in
{
  mylammps = mkCppShellWithPython (
    finalContext: with finalContext; {
      repoName = "mylammps";
      root = "/home/kein/repos/" + repoName;
      cmakeSourceDirectory = root + "/cmake";

      clangTidyConfText = [
        ''
          Checks: >
            cppcoreguidelines-pro-type-member-init

          CheckOptions:
            - key: cppcoreguidelines-pro-type-member-init.IgnoreArrays
              value: 'true'
        ''
      ];
      cppcheckSuppressions = [
        "noExplicitConstructor:src/nucc_cspan.hpp"
        "shiftTooManyBits:src/fix_cluster_crush_delete.cpp"
        "integerOverflow:src/fix_cluster_crush_delete.cpp"
      ];

      shellArgs.buildInputs = with shellPkgs; [
        adios2
        fftw
        zlib
        blas
        lapack
        zstd
        gzip
        libpng
      ];

      pythonPackages = [
        (
          ps: with ps; [
            pyzmq
            adios2
            mpi4py
            lizard # C++ linter
          ]
        )
      ];
    }
  );

  MDCraft = mkCppShellWithPython (
    finalContext: with finalContext; {
      repoName = "MDcraft";
      root = "/home/kein/repos/" + repoName;
      cmakeSourceDirectory = root;

      shellArgs.buildInputs = with shellPkgs; [
        fftw
        zlib
        blas
        lapack
        zstd
        gzip
      ];

      pythonPackages = [
        (
          ps: with ps; [
            pybind11
            mpi4py
            lizard # C++ linter
          ]
        )
      ];
    }
  );

  drmkernel = shells.mkCppShell (
    finalContext: with finalContext; {
      repoName = "drmkernel";
      root = "/home/kein/repos/" + repoName;
    }
  );

  cfproc = shells.mkPyShellInteractive (
    finalContext: with finalContext; {
      repoName = "cfproc";
      root = "/home/kein/Documents/nucleation/python/" + repoName;
      overlaidPythonPackages = [
        (final: prev: pyFinal: pyPrev: {
          lammps-logfile = pyFinal.callPackage ../pkgs/lammps-logfile.nix { };
        })
      ];
      pythonPackages = [ (ps: with ps; [ lammps-logfile ]) ];
      pyright_mode = "standard";
    }
  );

  lmptest = shells.mkPyShellInteractive (
    finalContext: with finalContext; {
      repoName = "lmptest";
      root = "/home/kein/Documents/nucleation/" + repoName;
      overlaidPythonPackages = [
        (final: prev: pyFinal: pyPrev: {
          lammps-logfile = pyFinal.callPackage ../pkgs/lammps-logfile.nix { };
        })
      ];
      pythonPackages = [ (ps: with ps; [ sympy lammps-logfile ]) ];
      pyright_mode = "standard";
    }
  );

  lmp = shells.mkPyShellInteractive (
    finalContext: with finalContext; {
      repoName = "lmp";
      root = "/home/kein/Documents/nucleation/" + repoName;
      pythonPackages = [
        (
          ps: with ps; [
            mpi4py
            pyzmq
            adios2
            toml
          ]
        )
      ];
      pyright_mode = "standard";
    }
  );

  themegen = shells.mkPyShell (
    finalContext: with finalContext; {
      repoName = "themegen";
      root = "/home/kein/repos/" + repoName;

      shellArgs.buildInputs = with shellPkgs; [ imagemagick ];
    }
  );

  latex = pkgs.mkShell {
    packages = with pkgs; [
      # texlive.combined.scheme-full
      ltex-ls-plus
    ];
  };

  peer-reviews = shells.mkPyShell (
    finalContext: with finalContext; {
      repoName = "peer-reviews";
      root = "/home/kein/Documents/" + repoName;

      pythonPackages = [ (ps: with ps; [ markdownify ]) ];
    }
  );
}
