# CyberClock v0.3

A transparent KDE Plasma 6 clock focused on animated typography and glitch effects.

## New in v0.3
- Font selector using installed system fonts
- Font size, weight, and letter-spacing controls
- Live font preview
- Effect presets: Clean, Matrix, Comic Glitch, Cyberpunk, Neon Pulse, Data Corruption, Chaos, Custom
- New CRT scanline effect masked inside the digits
- New breathing neon pulse
- New RGB ghost trail
- Existing Matrix rain, chromatic split, glitch slices, and heavy burst controls
- Transparent Plasma background

## Install / upgrade
```bash
kpackagetool6 --type Plasma/Applet --upgrade package
```

If it is not already installed:
```bash
kpackagetool6 --type Plasma/Applet --install package
```

Then restart Plasma if necessary:
```bash
systemctl --user restart plasma-plasmashell.service
```

## v0.3.2

- Added vertical scrolling to Appearance and Effects settings pages so all controls remain accessible in smaller configuration windows.


## v0.3.5
- Restored scrollbars in Appearance and Effects settings.
- Matrix rain uses the full-height seamless moving streams from v0.3.3.
- Reworked digit masking using same-size layered alpha text so rain is confined to glyphs without disappearing.
