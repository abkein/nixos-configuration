{ pkgs, lib }:
let
  mkPlugin =
    {
      pname,
      version,
      src,
      meta ? { },
      ...
    }:
    pkgs.stdenv.mkDerivation {
      inherit
        pname
        src
        version
        meta
        ;

      dontBuild = true;
      installPhase = ''
        runHook preInstall

        mkdir -p "$out"
        cp -r . "$out/"

        runHook postInstall
      '';
    };

  plugins = {
    editorconfig = rec {
      version = "1.1.0";

      src = pkgs.fetchFromGitHub {
        repo = "editorconfig-micro";
        owner = "10sr";
        rev = "v${version}";
        sha256 = "sha256-dCLM0Dz95iwZp3nYqQC0Wg9xzcF+z9m5NQK0uabWzEE=";
      };

    };
    manipulator = rec {
      version = "1.4.1";

      src = pkgs.fetchFromGitHub {
        repo = "manipulator-plugin";
        owner = "NicolaiSoeborg";
        rev = "v${version}";
        sha256 = "sha256-2zr+YueKpU4RnmomhEHdZHaKi9cY3I0mbd8tTtsovKs=";
      };
    };
    quoter = rec {
      version = "1.0.3";

      src = pkgs.fetchFromGitHub {
        repo = "micro-quoter";
        owner = "sparques";
        rev = "v${version}";
        sha256 = "sha256-BX0Vj1ZVP7FlcG/4D7x1V0MmZ/IYNEmIcpcqubZLabQ=";
      };
    };
    autofmt = rec {
      version = "3.0.0";

      src = pkgs.fetchFromGitHub {
        repo = "micro-autofmt";
        owner = "a11ce";
        rev = version;
        sha256 = "sha256-0AB9dkZHFW5bgNduha0DH4KpSanx+57wiqpxYxF23Po=";
      };
    };
    detectindent = rec {
      version = "1.1.0";

      src = pkgs.fetchFromGitHub {
        repo = "micro-detectindent";
        owner = "dmaluka";
        rev = "v${version}";
        sha256 = "sha256-5bKEkOnhz0pyBR2UNw5vvYiTtpd96fBPTYW9jnETvq4=";
      };
    };
  };
in
lib.mapAttrs (pname: plugin: mkPlugin (plugin // { inherit pname; })) plugins
