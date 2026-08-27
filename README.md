# Dreaming Omarchy theme

A soft, desaturated purple-pink dark theme with three wallpapers included.

![Preview with bgs](preview.png "backgrounds")

![Homescreen preview with apps open](assets/homescreen.png "Homescreen preview")

## Install

```bash
omarchy-theme-install https://github.com/herny22/omarchy-dreaming-theme.git
```

### Matching folder icons

Omarchy can only point the icon setting at an icon theme that already exists on
your machine, and it won't run scripts from an installed theme.
Therefore, the custom folder colours need one manual command after install:

```bash
bash ~/.config/omarchy/themes/dreaming/install-icons.sh
omarchy theme set dreaming
```

`install-icons.sh` recolours the stock **Yaru-purple** folder icons to a mauve better suited to the theme, writes them to `~/.local/share/icons/Yaru-dreaming`, and installs
a `theme-set` hook so they're rebuilt automatically if they ever go missing.
Note that this requires `imagemagick` and `yaru-icon-theme`, both of which already ship with Omarchy as standard.

To change the tint, edit the `MODULATE` value (`brightness,saturation,hue`) at
the top of `install-icons.sh` and re-run it.

### Matching GTK apps / file manager colours (one extra step)

Omarchy doesn't theme GTK/libadwaita apps — Nautilus and friends stay stock
Adwaita grey. `gtk.css` in this repo carries `@define-color` overrides matching
`colors.toml`; `omarchy theme set` stages it to
`~/.local/state/omarchy/current/theme/gtk.css`, but nothing points GTK at it
until you run:

```bash
bash ~/.config/omarchy/themes/dreaming/install-gtk.sh
omarchy theme set dreaming
```

`install-gtk.sh` writes a one-line `@import` into `~/.config/gtk-3.0/gtk.css`
and `~/.config/gtk-4.0/gtk.css` (backing up anything already there to
`gtk.css.pre-dreaming.bak`) and installs a `theme-set` hook that restarts
Nautilus when Dreaming is applied. The import tracks the *current* theme, so it
stays dormant under other themes — GTK just logs one "file not found" warning
for each `gtk.css`; add a `gtk.css` to those themes too if that bothers you.
