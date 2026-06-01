Hello!

TODO:

1. Loki?
2. Grafana?


Hi!
There's a slight problem with my setup: when I start a GTK app from terminal, I get a warning from `dconf`:
```
$ xed

(xed:18562): dconf-WARNING **: 09:09:17.557: Unable to open /home/kein/.local/state/nix/profile/share/dconf/profile/user: Not a directory
```
And indeed there's no such a directory. I suspect the apps are trying to access this path on startup to fetch something from dconf. This path is only mentioned in environmental variables: `$XCURSOR_PATH`, `$XDG_DATA_DIRS`, `$INFOPATH` and `$TERMINFO_DIRS`:
```
XCURSOR_PATH=/etc/profiles/per-user/kein/share/icons:/home/kein/.icons:/home/kein/.local/share/icons:/home/kein/.nix-profile/share/icons:/home/kein/.nix-profile/share/pixmaps:/nix/profile/share/icons:/nix/profile/share/pixmaps:/home/kein/.local/state/nix/profile/share/icons:/home/kein/.local/state/nix/profile/share/pixmaps:/etc/profiles/per-user/kein/share/icons:/etc/profiles/per-user/kein/share/pixmaps:/nix/var/nix/profiles/default/share/icons:/nix/var/nix/profiles/default/share/pixmaps:/run/current-system/sw/share/icons:/run/current-system/sw/share/pixmaps
INFOPATH=/home/kein/.nix-profile/info:/home/kein/.nix-profile/share/info:/nix/profile/info:/nix/profile/share/info:/home/kein/.local/state/nix/profile/info:/home/kein/.local/state/nix/profile/share/info:/etc/profiles/per-user/kein/info:/etc/profiles/per-user/kein/share/info:/nix/var/nix/profiles/default/info:/nix/var/nix/profiles/default/share/info:/run/current-system/sw/info:/run/current-system/sw/share/info
TERMINFO_DIRS=/home/kein/.nix-profile/share/terminfo:/nix/profile/share/terminfo:/home/kein/.local/state/nix/profile/share/terminfo:/etc/profiles/per-user/kein/share/terminfo:/nix/var/nix/profiles/default/share/terminfo:/run/current-system/sw/share/terminfo
XDG_DATA_DIRS=/nix/store/r8g7wx039a0kcc3chmxrni9qflxjs802-ghostty-1.3.1/share:/nix/store/k8a44404day9i86sxkjm0gq5ymlvyh06-gsettings-desktop-schemas-50.1/share/gsettings-schemas/gsettings-desktop-schemas-50.1:/nix/store/hkg2i77ydzyym51dql6q375lnf29f17a-gtk4-4.22.4/share/gsettings-schemas/gtk4-4.22.4:/nix/store/w92y8xiymxjg5d61ysdjmdi9zk6w3jj4-desktops/share:/home/kein/.nix-profile/share:/nix/profile/share:/home/kein/.local/state/nix/profile/share:/etc/profiles/per-user/kein/share:/nix/var/nix/profiles/default/share:/run/current-system/sw/share
```

The most interesting to me is why are these variables the way they are. Because if we'd run
```
$ nix eval --json .\#nixosConfigurations.jeta.config.home-manager.users.kein.home.sessionVariables
{
  "CARGO_HOME": "/home/kein/.local/share/cargo",
  "CLAUDE_CONFIG_DIR": "/home/kein/.config/claude",
  "CLUTTER_BACKEND": "wayland",
  "CODEX_HOME": "/home/kein/.config/codex",
  "DOTNET_CLI_HOME": "/home/kein/.local/share/dotnet",
  "ELECTRUMDIR": "/home/kein/.local/share/electrum",
  "GDK_BACKEND": "wayland,x11,*",
  "GNUPGHOME": "/home/kein/.local/share/gnupg",
  "GTK2_RC_FILES": "/home/kein/.config/gtk-2.0/gtkrc",
  "HYPRCURSOR_SIZE": 20,
  "HYPRCURSOR_THEME": "Bibata-Modern-Classic",
  "IPYTHONDIR": "/home/kein/.config/ipython",
  "JAVA_HOME": "/nix/store/v3n6jl0sxn64g97c5kxzriwj4fv6qnjh-openjdk-21.0.12+2/lib/openjdk",
  "JUPYTER_CONFIG_DIR": "/home/kein/.config/jupyter",
  "LOCALE_ARCHIVE_2_27": "/nix/store/pg0h4abp75vwjrv8ndiy21cxln7ijibz-glibc-locales-2.42-61/lib/locale/locale-archive",
  "MOZ_HOME": "/home/kein/.config/mozilla",
  "NPM_CONFIG_CACHE": "/home/kein/.cache/npm",
  "NPM_CONFIG_INIT_MODULE": "/home/kein/.config/npm/config/npm-init.js",
  "NPM_CONFIG_TMP": "/run/user/1000/npm",
  "PYTHONSTARTUP": "/home/kein/.config/python/pythonrc",
  "PYTHON_HISTORY": "/home/kein/.local/state/python_history",
  "QT_AUTO_SCREEN_SCALE_FACTOR": "1",
  "QT_QPA_PLATFORM": "wayland;xcb",
  "QT_QPA_PLATFORMTHEME": "qt5ct",
  "QT_STYLE_OVERRIDE": "kvantum",
  "QT_WAYLAND_DISABLE_WINDOWDECORATION": "1",
  "RUSTUP_HOME": "/home/kein/.local/share/rustup",
  "SDL_VIDEODRIVER": "wayland",
  "SONARLINT_USER_HOME": "/home/kein/.local/share/sonarlint",
  "XCURSOR_SIZE": 20,
  "XCURSOR_THEME": "Bibata-Modern-Classic",
  "XDG_BIN_HOME": "/home/kein/.local/bin",
  "XDG_CACHE_HOME": "/home/kein/.cache",
  "XDG_CONFIG_DIRS": "/nix/store/f4s0vhdcjsqmpa69x5hb7awx3ccr18qc-stylix-kde-config${XDG_CONFIG_DIRS:+:$XDG_CONFIG_DIRS}",
  "XDG_CONFIG_HOME": "/home/kein/.config",
  "XDG_DATA_HOME": "/home/kein/.local/share",
  "XDG_DESKTOP_DIR": "/home/kein/Desktop",
  "XDG_DOCUMENTS_DIR": "/home/kein/Documents",
  "XDG_DOWNLOAD_DIR": "/home/kein/Downloads",
  "XDG_MUSIC_DIR": "/home/kein/Music",
  "XDG_PICTURES_DIR": "/home/kein/Pictures",
  "XDG_PROJECTS_DIR": "/home/kein/Projects",
  "XDG_PUBLICSHARE_DIR": "/home/kein/Public",
  "XDG_SCREENSHOTS_DIR": "/home/kein/Pictures/Screenshots",
  "XDG_STATE_HOME": "/home/kein/.local/state",
  "XDG_TEMPLATES_DIR": "/home/kein/Templates",
  "XDG_VIDEOS_DIR": "/home/kein/Videos",
  "XDG_WALLPAPERS_DIR": "/home/kein/Pictures/Wallpapers"
}
```

