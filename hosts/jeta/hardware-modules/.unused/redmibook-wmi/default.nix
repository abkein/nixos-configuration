{ config, ... }:

let
  redmibookWmi = config.boot.kernelPackages.callPackage (
    {
      stdenv,
      lib,
      kernel,
      kernelModuleMakeFlags,
      ...
    }:
    stdenv.mkDerivation {
      pname = "redmibook-wmi";
      version = "1.0.3";

      src = ./redmibook-wmi;

      nativeBuildInputs = kernel.moduleBuildDependencies;

      # Build against the currently selected kernel
      makeFlags = kernelModuleMakeFlags ++ [
        "KERNELRELEASE=${kernel.modDirVersion}"
        "-C"
        "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
        "M=$(PWD)"
        "INSTALL_MOD_PATH=${placeholder "out"}"
        "INSTALL_MOD_DIR=extra"
        "INSTALL_MOD_STRIP=1"
        "DEPMOD=true"
      ];

      buildFlags = [ "modules" ];

      # Also generate the module certificate required by the kernel modules tree.
      installTargets = [ "modules_install" ];

      meta = with lib; {
        description = "WMI hotkey driver for Xiaomi RedmiBook 15 series";
        platforms = platforms.linux;
        license = licenses.gpl2;
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
