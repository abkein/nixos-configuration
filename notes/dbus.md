## Original issue

The messages `dbus-broker-launch: Ignoring duplicate name` are caused by duplicate D-Bus activation service files, not by failing services.

Root cause:

- The evaluated NixOS `services.dbus.packages` contains both `system-path` and the individual packages inside it, for example `networkmanager`, `iwd`, `bluez`, `upower`, `udisks`, `polkit`, `xdg-desktop-portal`, `thunar`, `gvfs`, etc.
- `/etc/dbus-1/system.conf` and `/etc/dbus-1/session.conf` therefore expose the same `.service` files through two paths:
  - merged profile path such as `/nix/store/...-system-path/share/dbus-1/...`
  - original package path such as `/nix/store/...-networkmanager-.../share/dbus-1/...`
- `dbus-broker-launch` sees the same `Name=` twice and logs `Ignoring duplicate name ...` for the later copy.

So these are mostly noise from Nix/NixOS profile composition. `dbus-broker` keeps one activation entry and ignores the duplicate.

From docs

> Subject: Invalid service file
> Defined-By: dbus-broker
> Support: https://groups.google.com/forum/#!forum/bus1-devel
>
> A service file is a ini-type configuration file.
>
> It has one required section
> named [D-BUS Service]. The section contains the required key 'Name', which
> must be a valid D-Bus name that is unique across all service files. It also
> contains at least one of the two optional keys 'SystemdService' and 'Exec',
> as well as optionally the key 'User'. Exec must be a valid shell command and
> User must be a valid user on the system.
>
> A service file should be named after the D-Bus name it configures. That is
> a file containing Name=org.foo.bar1 should be named org.foo.bar1.service.
> For backwards compatibility, we only warn when files do not follow this
> convention when run as a user bus. The system bus considers this an error
> and ignores the service file.

## Quick workaround (filtering)

```nix
{
  systemd.services.dbus-broker.serviceConfig.LogFilterPatterns = [
    "~Ignoring duplicate name '.*' in service file '.*'"
  ];

  systemd.user.services.dbus-broker.serviceConfig.LogFilterPatterns = [
    "~Ignoring duplicate name '.*' in service file '.*'"
  ];
}
```

## Thoughts

Apparently I think that DBus does the right thing that warns about duplicates.
The core issue are separate mechanisms that duplicate each other:
`environment.pathsToLink` (and therefore `system.path`) and `services.dbus.packages`,
which internally includes `system.path`.

A workaround at NixOS level could be fintering these paths at the `services.dbus`
module level. This cannot be done, though, because `system.path` is a derivation,
and the actual paths in it are unknown at eval-time.

I see one proper solution, which requires design change of packages: instead of
collecting everything into `system.path`, introduce `toSystemPath` (or whatever)
parameter at package level. So the package ahead declares its paths that need to
be symlinked. This could be more granularly, e.g. separate `dbus-services`,
`systemd-services`, `systemd-user-services`, etc. Or, this could be done via `outputs`
mechanism.

The core idea is to make a package declare in advance that its subpaths
need to be symlinked and not make `system.path` garbage-collect everything under
`environment.pathsToLink` from each package. In this case, we won't even need to
add `<pkg>/share/dbus-1` to `system.path`, because they are automatically added to
`services.dbus.packages = builtins.map (pkg: pkg.dbusPaths) environment.systemPackages;`.

And the same with others, i.e. `/etc/xdg`, `/share/systemd`, `/bin`, `/sbin`, etc.

For a gradual transition, one could add `apiVersion = 2;` flag — packages with 1 are
automatically symlinked by old paths-to-link mechanism, while ones with 2, go the new
way. This (api versioning) could actually make easier to make other API changes, just
like we already have with `system.stateVersion`. Alternatively, it could be
`symlinkFHS = true;` flag.
