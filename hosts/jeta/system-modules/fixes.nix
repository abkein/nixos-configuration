{ pkgs, ... }: {
  # See [notes/dbus.md]
  systemd = {
    services.dbus-broker.serviceConfig.LogFilterPatterns = [
      "~Ignoring duplicate name '.*' in service file '.*'"
    ];

    user.services.dbus-broker.serviceConfig.LogFilterPatterns = [
      "~Ignoring duplicate name '.*' in service file '.*'"
    ];
  };

  # Wring placement of icons
  environment.systemPackages = with pkgs; [
    (runCommand "blueman-icon-fix" { } ''
      mkdir -p $out/share/icons/hicolor/scalable/apps
      ln -s ${blueman}/share/icons/hicolor/scalable/devices/blueman-device.svg \
        $out/share/icons/hicolor/scalable/apps/blueman-device.svg

      mkdir -p $out/share/icons/hicolor/16x16/apps
      ln -s ${blueman}/share/icons/hicolor/16x16/devices/blueman-device.png \
        $out/share/icons/hicolor/16x16/apps/blueman-device.png
    '')
  ];
}
