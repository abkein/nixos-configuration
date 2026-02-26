{
  config,
  ...
}:

let
  redmibookWmi = config.boot.kernelPackages.callPackage (
    {
      stdenv,
      lib,
      kernel,
      ...
    }:
    stdenv.mkDerivation {
      pname = "redmibook-wmi";
      version = "1.0.3";

      src = ./redmibook-wmi;

      nativeBuildInputs = kernel.moduleBuildDependencies;

      # Build against the currently selected kernel
      makeFlags = [
        "KERNELRELEASE=${kernel.modDirVersion}"
        "-C"
        "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
        "M=$(PWD)"
        "modules"
      ];

      buildPhase = ''
        runHook preBuild
        make ''${makeFlags[@]}
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        mkdir -p $out/lib/modules/${kernel.modDirVersion}/extra
        cp redmibook_wmi.ko $out/lib/modules/${kernel.modDirVersion}/extra/
        runHook postInstall
      '';

      meta = with lib; {
        description = "WMI hotkey driver for Xiaomi RedmiBook 15 series";
        platforms = platforms.linux;
        license = licenses.gpl3;
        homepage = "https://github.com/vrolife/modern_laptop";
        broken = false;
        maintainers = with lib.maintainers; [ abkein ];
      };
    }
  ) { };
in
{
  boot.extraModulePackages = [ redmibookWmi ];
  boot.kernelModules = [ "redmibook_wmi" ];

  # Optional: enable debug dumping from the module (your module_param)
  # boot.extraModprobeConfig = ''
  #   options redmibook_wmi dump_event_data=1
  # '';
}
