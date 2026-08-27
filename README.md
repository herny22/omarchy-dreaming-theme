# Dreaming Omarchy theme

A soft, desaturated purple-pink dark theme.

![Homescreen preview with apps open](assets/homescreen.png "Homescreen preview")

## Install

```bash
omarchy-theme-install https://github.com/herny22/omarchy-dreaming-theme.git
```

### Matching folder icons (one extra step)

Omarchy can only point the icon setting at an icon theme that already exists on
your machine, and it won't run scripts from an installed theme. So the custom
folder colours need one manual command after install:

```bash
~/.config/omarchy/themes/dreaming/install-icons.sh
omarchy theme set dreaming
```

`install-icons.sh` recolours the stock **Yaru-purple** folder icons to a mauve better suited to the theme, writes them to `~/.local/share/icons/Yaru-dreaming`, and installs
a `theme-set` hook so they're rebuilt automatically if they ever go missing.
This requires `imagemagick` and `yaru-icon-theme`, both of which ship with Omarchy.

To change the tint, edit the `MODULATE` value (`brightness,saturation,hue`) at
the top of `install-icons.sh` and re-run it.
