{ config, pkgs, ... }:
# let
#   sessions = config.services.displayManager.sessionData.desktops;
#   runTuigreet = pkgs.writeShellScript "run-tuigreet" ''
#     exec ${pkgs.tuigreet}/bin/tuigreet \
#       --time --user-menu       \
#       --debug /var/log/tuigreet/tuigreet-debug.log    \
#       --sessions "${sessions}/share/wayland-sessions" \
#       --power-shutdown '${pkgs.systemd}/bin/poweroff' \
#       --power-reboot '${pkgs.systemd}/bin/reboot'
#   '';
# in
{
  imports = [ ../../../../options/nixos/tuigreet.nix ];

  # services.greetd = {
  #   enable = true;
  #   useTextGreeter = true;
  #   settings.default_session.command = runTuigreet;
  # };
  # environment.systemPackages = with pkgs; [ tuigreet ];

  programs.tuigreet = {
    enable = true;
    session.enable = true;
    greeting = "Hello!";
    time.enable = true;
    remember = {
      user = true;
      session = true;
      userSession = true;
    };
    userMenu.enable = true;
    power = {
      shutdown = "${pkgs.systemd}/bin/poweroff";
      reboot = "${pkgs.systemd}/bin/reboot";
    };
    theme = {
      border="magenta";
      text="cyan";
      prompt="green";
      time="red";
      action="blue";
      button="yellow";
      container="black";
      input="red";
    };
  };
}
