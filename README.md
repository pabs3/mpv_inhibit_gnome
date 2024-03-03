# `mpv_inhibit_gnome`

This mpv plugin prevents screen blanking in GNOME while playing media.

This is needed because neither mpv supports GNOME's inhibition protocol, nor
GNOME supports the standard inhibition protocol
([yet](https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/111)).

## Compatibility

This plugin requires mpv to be built with `--enable-cplugins` (default as of mpv 0.26)
and to be built with Lua support (to enable loading scripts).

## Loading

mpv will automatically load the plugin from the following directories:

- `/etc/mpv/scripts`: for all users
- `~/.config/mpv/scripts`: for current user

mpv can also manually load the plugin from other directories:

```
mpv --script=/path/to/mpv_inhibit_gnome.so video.mp4
```

## Installing

Packages are available for many [distributions](https://repology.org/project/mpv-mpris/versions).

[![AUR version](https://img.shields.io/aur/version/mpv_inhibit_gnome)](https://aur.archlinux.org/packages/mpv_inhibit_gnome)
[![COPR version](https://img.shields.io/badge/dynamic/json?color=blue&label=copr&query=builds.latest_succeeded.source_package.version&url=https%3A%2F%2Fcopr.fedorainfracloud.org%2Fapi_3%2Fpackage%3Fownername%3Dsolopasha%26projectname%3Dmpv_inhibit_gnome%26packagename%3Dmpv_inhibit_gnome%26with_latest_succeeded_build%3DTrue)](https://copr.fedorainfracloud.org/coprs/solopasha/mpv_inhibit_gnome/)

For 64-bit x86 Linux a pre-built version is [available here](https://github.com/Guldoman/mpv_inhibit_gnome/releases)
and can be loaded into mpv as documented above.

## Building

Build requirements:
 - C99 compiler (gcc or clang)
 - pkg-config
 - mpv development files
 - libdbus development files

Building should be as simple as running `make` in the source code directory and
this will generate the plugin in `lib/mpv_inhibit_gnome.so`.

To install in the default per-user location `~/.config/mpv/scripts`
either copy it there or run:
```bash
make install
```

To install in the default system-wide location `/usr/share/mpv/scripts` run:
```bash
sudo make sys-install
```

## Flatpak support

This plugin has been integrated into the
[Flatpak release of mpv](https://flathub.org/apps/details/io.mpv.Mpv),
so you should already be good to go.

If this plugin was manually installed before the integration,
uninstall it to avoid conflicts by deleting
`~/.var/app/io.mpv.Mpv/config/mpv/scripts/mpv_inhibit_gnome.so`.
