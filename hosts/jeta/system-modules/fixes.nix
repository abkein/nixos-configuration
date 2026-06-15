{ config, pkgs, ... }: {
  # See [notes/dbus.md]
  systemd = {
    # services.dbus-broker.serviceConfig.LogFilterPatterns = [
    #   "~Ignoring duplicate name '.*' in service file '.*'"
    # ];

    user.services = {
      # dbus-broker.serviceConfig.LogFilterPatterns = [
      #   "~Ignoring duplicate name '.*' in service file '.*'"
      # ];

      wireplumber = {
        environment.SPA_PLUGIN_DIR = "${config.services.pipewire.package}/lib/spa-0.2";
        # serviceConfig.LogFilterPatterns = [
        #   "~spa.alsa: Path Mic ACP LED is not a volume or mute control"
        #   "~default: Failed to get percentage from UPower: org.freedesktop.DBus.Error.NameHasNoOwner"
        # ];
      };

      # pipewire-pulse.serviceConfig.LogFilterPatterns = [
      #   "~mod.protocol-pulse: setsockopt\\(SO_PRIORITY\\) failed: Bad file descriptor"
      #   "~mod.protocol-pulse: client .*: no peercred: Bad file descriptor"
      # ];

      # xdg-desktop-portal.serviceConfig.LogFilterPatterns = [
      #   "~Realtime error: Could not get pidns for pid .*: Could not fstatat ns/pid: Not a directory"
      # ];

      # hyprpolkitagent.serviceConfig.LogFilterPatterns = [
      #   "~Failed to register with host portal QDBusError\\(\"org.freedesktop.portal.Error.Failed\", \"Could not register app ID: App info not found for ''\"\\)"
      # ];

      # syncthingtray.serviceConfig.LogFilterPatterns = [
      #   "~QDBusTrayIcon encountered a D-Bus error: QDBusError\\(\"org.freedesktop.DBus.Error.ServiceUnknown\", \"The name is not activatable\"\\)"
      #   "~Failed to register with host portal QDBusError\\(\"org.freedesktop.portal.Error.Failed\", \"Could not register app ID: App info not found for ''\"\\)"
      # ];
    };
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
