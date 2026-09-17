# RGB (OpenRGB + NVIDIA GPU)

All RGB follows the active Noctalia palette through a **user template**, exactly
like the other app themes. Two backends are used: OpenRGB for most hardware, and
a small NVAPI helper for the GPU (which OpenRGB cannot detect). Both are
Arch-only, as is the integration.

## How it works

```
noctalia palette ─▶ template engine ─▶ ~/.cache/noctalia/openrgb.sh ─▶ post_hook runs it
                                                                        ├─ openrgb
                                                                        └─ nvapi-illum
```

The template source is `noctalia/templates/openrgb.sh`, registered in
`noctalia/config.toml` under `[theme.templates.user.openrgb]`. Noctalia renders
the palette's accent into a small shell script and runs it via the entry's own
`post_hook`. This happens at login (Noctalia applies templates when it loads)
and again whenever the palette changes.

Two shades of the accent are used:

- **`accent`** — primary put through the `darken 15` filter. The raw primary is
  deliberately pale and washes out to white on LEDs.
- **`dim`** — primary put through `darken 70`, for the in-case devices, which are
  physically much brighter.

## What is controlled

OpenRGB devices are matched by a substring of their OpenRGB name and given the
mode that makes them solid (OpenRGB has no cross-device "static" mode):

| Device | Backend | Mode | Shade |
|---|---|---|---|
| ASUS motherboard (Aura zone + ARGB headers) | OpenRGB | `Static` | `dim` |
| Corsair Vengeance RGB DDR5 | OpenRGB | `Direct` | `dim` |
| Keychron K2 | OpenRGB | `Solid Color` | `accent` |
| Logitech G305 | OpenRGB | `Static` | `accent` |
| Gainward RTX 4070 SUPER Ghost | `nvapi-illum` | — | `dim` |

Case fans hang off the motherboard's addressable RGB headers. Those are
resizable OpenRGB zones that start empty, so the script sets each header zone to
30 LEDs (`--zone N --size 30`) before applying the colour — that is what makes
the fans follow the theme.

OpenRGB re-detects all hardware on every invocation (several seconds) and a
combined command aborts if any named device is absent. The script therefore
probes once, builds the argument list from the devices that are present, and
issues a single set-and-apply call.

## The GPU (`bin/nvapi-illum`)

OpenRGB has no device entry for this card (`10de:2783` / subsystem
`10b0:f303`), so it cannot see it. The card's lighting is instead reachable
through NVIDIA's NVAPI "client illumination zones" API, which the Linux driver
exposes via `libnvidia-api.so`. `bin/nvapi-illum` calls that API directly with
`ctypes` (no build step, no OpenRGB patch) and is stowed to `~/.config/bin/`.

The helper is wired into the same generated script, so the GPU follows the
palette like everything else. It supports:

```
nvapi-illum --list                       # GPUs and zones, with current values
nvapi-illum --off                        # turn all zones off
nvapi-illum --color RRGGBB [--brightness 0-100]
```

Unlike the ASUS/Corsair modes, the GPU honours a real brightness percentage, so
it is given the `dim` shade at 100%.

## Why dimming is a colour for the other devices

OpenRGB's `--brightness` is silently ignored on the ASUS `Static` and Corsair
`Direct` modes: setting it to 1% produced no visible change. Those devices are
therefore dimmed by using a darker shade of the accent. The GPU is not affected
by this — its brightness is a real control.

## Tuning

- **Shades / palette role**: change the filter expressions on the `accent=` and
  `dim=` lines in `noctalia/templates/openrgb.sh`, e.g.
  `{{ colors.secondary.default.hex_stripped | darken 15 }}`.
- **GPU colour / brightness**: the invocation near the end of the template
  (`nvapi-illum --color "$dim" --brightness 100`).
- **Different hardware**: edit the `add` lines
  (`add <colour> <name> <mode> [extra…]`) to match device names and modes shown
  by `openrgb --list-devices`.
- **Apply after editing**: `noctalia msg templates-apply`. Note that
  `noctalia msg config-reload` reloads config but does *not* re-apply templates;
  a template edit needs `templates-apply`.

## Known limitations

- **Corsair cooler**: OpenRGB supports many Corsair coolers, but none appear as
  a USB device here — the cooler's USB cable is not connected. No software can
  reach it until that cable goes to a motherboard USB header.
- **GPU without an NVIDIA driver**: `nvapi-illum` exits 0 with a message, so the
  hook stays harmless on machines without `libnvidia-api`.
