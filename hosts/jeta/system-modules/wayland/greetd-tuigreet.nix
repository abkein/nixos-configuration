{ config, pkgs, ... }:
let
  sessionData = config.services.displayManager.sessionData;
  #   log=/var/log/tuigreet/tuigreet.log
  #   {
  runTuigreet = pkgs.writeShellScript "run-tuigreet" ''
    exec ${pkgs.tuigreet}/bin/tuigreet \
      --time --user-menu       \
      --debug /var/log/tuigreet/tuigreet-debug.log    \
      --sessions "${sessionData.desktops}/share/wayland-sessions" \
      --power-shutdown '${pkgs.systemd}/bin/poweroff' \
      --power-reboot '${pkgs.systemd}/bin/reboot'
  '';
  #    --kb-command 1 --kb-sessions 2 --kb-power 3
  #'';
  #   } > "$log" 2>&1
in
{
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings.default_session.command = runTuigreet;
  };
  environment.systemPackages = with pkgs; [ tuigreet ];
}
