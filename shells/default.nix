{
  nixpkgs,
  lib ? nixpkgs.lib,
  system,
  mylib,
  root-overlays ? [ ],
}:
let
  shell-tools = import ./shell-tools.nix {
    inherit
      nixpkgs
      system
      mylib
      root-overlays
      ;
  };
  shells = import ./shell-collection.nix {
    inherit lib shell-tools;
    root-overlaidPythonPackages = [
      (final: prev: pyFinal: pyPrev: {
        numpy-typing-compat = pyFinal.callPackage ./temporary-python-packages/numpy-typing-compat.nix { };
        optype = pyFinal.callPackage ./temporary-python-packages/optype.nix { };
        scipy-stubs = pyFinal.callPackage ./temporary-python-packages/scipy-stubs.nix { };
      })
    ];
  };

  mkCppShellWithPython = shells.mkCppShell.extend shells.modules.pythonBase;
in
{
  lammps = mkCppShellWithPython (
    finalContext: with finalContext; {
      repoName = "lammps";
      root = "/home/kein/repos/" + repoName;
      cmakeSourceDirectory = root + "/cmake";

      clangTidyConf.CheckOptions = {
        "cppcoreguidelines-pro-type-member-init.IgnoreArrays" = true;
      };
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
          ]
        )
      ];
    }
  );

  ocp-framework = shells.mkCppShell (
    finalContext: with finalContext; {
      repoName = "ocp-framework";
      root = "/home/kein/repos/" + repoName;
      cmakeSourceDirectory = root + "/src";

      shellArgs.buildInputs = with shellPkgs; [ adios2 ];
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
      pythonPackages = [
        (
          ps: with ps; [
            lammps-logfile
            camelot
            scikit-learn
          ]
        )
      ];
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
      shellArgs.buildInputs = with shellPkgs; [
        meson
        gfortran
        pkg-config
        ninja
      ];
      pythonPackages = [
        (
          ps: with ps; [
            sympy
            lammps-logfile
          ]
        )
      ];
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

  latex = shells.emptyShell (
    finalContext: with finalContext; {
      shellArgs.packages = with shellPkgs; [
        # texlive.combined.scheme-full
        ltex-ls-plus
      ];
    }
  );

  peer-reviews = shells.mkPyShell (
    finalContext: with finalContext; {
      repoName = "peer-reviews";
      root = "/home/kein/Documents/" + repoName;

      pythonPackages = [ (ps: with ps; [ markdownify ]) ];
    }
  );

  mob-guide = shells.mkPyShellInteractive (
    finalContext: with finalContext; {
      repoName = "mob-guide";
      root = "/home/kein/Documents/" + repoName;

      pythonPackages = [
        (
          ps: with ps; [
            curl-cffi
            markdownify
            marko
            beautifulsoup4
          ]
        )
      ];
    }
  );

  chatgpt = shells.mkPyShell (
    finalContext: with finalContext; {
      repoName = "chatgpt";
      root = "/home/kein/Projects/" + repoName;

      pythonPackages = [ (ps: with ps; [ pysocks ]) ];
    }
  );

  nixy = shells.mkPyShell (
    finalContext: with finalContext; {
      repoName = "nixy";
      root = "/home/kein/" + repoName;

      pythonPackages = [
        (
          ps: with ps; [
            json-repair
            marko
            pyyaml
            types-pyyaml
          ]
        )
      ];
    }
  );
}
