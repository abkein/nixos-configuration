{
  # config,
  pkgs,
  ...
}:
{
  imports = [
    ../../universal/home-modules/home.nix
    ../../universal/home-modules/shell.nix
    ../../universal/home-modules/fix-python-history.nix
    ./home-modules
  ];

  home = {
    stateVersion = "25.11";
    packages = with pkgs; [
      (python3.withPackages (
        ps: with ps; [
          bash-kernel
          ipython
          ipykernel
          isort
          numpy
          pandas
          scipy
          requests
        ]
      ))
    ];
  };

  systemd.user.tmpfiles.rules = [
    # "d ${config.programs.gpg.homedir} 0700 ${config.home.username} users - -"
    # "d ${config.home.homeDirectory}/.ssh 0700 ${config.home.username} users - -"
  ];
}
