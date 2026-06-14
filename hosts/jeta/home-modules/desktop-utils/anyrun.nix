{ ... }: {
  programs.anyrun = {
    enable = false;
    config = {
      x = {
        fraction = 0.5;
      };
      y = {
        fraction = 0.3;
      };
      width = {
        fraction = 0.3;
      };
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = false;
      closeOnClick = false;
      showResultsImmediately = false;
      maxEntries = null;
      # plugins = with anyrun-pkgs; [
      #   # An array of all the plugins you want, which either can be paths to the .so files, or their packages
      #   applications
      #   dictionary # :def
      #   shell # :sh
      #   rink
      #   symbols
      #   websearch # ?
      # ];
    };
    extraConfigFiles = {
      "applications.ron".text = ''
        Config(
          // Also show the Desktop Actions defined in the desktop files, e.g. "New Window" from LibreWolf
          desktop_actions: true,

          max_entries: 50,

          // A command to preprocess the command from the desktop file. The commands should take arguments in this order:
          // command_name <term|no-term> <command>
          // preprocess_exec_script: Some("/home/user/.local/share/anyrun/preprocess_application_command.sh")

          // The terminal used for running terminal based desktop entries, if left as `None` a static list of terminals is used
          // to determine what terminal to use.
          terminal: Some(Terminal(
            // The main terminal command
            command: "kitty",
            // What arguments should be passed to the terminal process to run the command correctly
            // {} is replaced with the command in the desktop entry
            args: "--hold --app-id="kitty_quick" {}",
          )),
        )
      '';
    };
  };
}
