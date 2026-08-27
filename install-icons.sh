#!/bin/bash
# Builds the "Yaru-dreaming" icon theme: Yaru-purple's folder icons recoloured
# to the desaturated mauve of the Dreaming theme. Run this once after
# `omarchy theme install`, then run `omarchy theme set dreaming`.
#
# Requires: imagemagick, gtk-update-icon-cache, yaru-icon-theme
# (all ship with Omarchy by default).

set -euo pipefail

SRC=/usr/share/icons/Yaru-purple
DST="${XDG_DATA_HOME:-$HOME/.local/share}/icons/Yaru-dreaming"
MODULATE="100,53,123"   # brightness,saturation,hue — mauve shift matching colors.toml

if [[ ! -d $SRC ]]; then
  echo "Yaru-purple not found at $SRC. Install it with: omarchy pkg add yaru-icon-theme" >&2
  exit 1
fi

echo "Building $DST ..."
rm -rf "$DST"
mkdir -p "$DST"

# index.theme: inherit the stock Yaru-purple set, override only the folders below.
sed -E \
  -e 's/^Name=.*/Name=Yaru-dreaming/' \
  -e 's/^Comment=.*/Comment=Desaturated purple folders for the Dreaming theme (Yaru-purple base)/' \
  -e 's/^Inherits=.*/Inherits=Yaru-purple,Yaru,Humanity,hicolor/' \
  "$SRC/index.theme" > "$DST/index.theme"

count=0
while IFS= read -r -d '' f; do
  rel="${f#"$SRC"/}"
  mkdir -p "$DST/$(dirname "$rel")"
  magick "$f" -modulate "$MODULATE" "$DST/$rel"
  count=$((count + 1))
done < <(find "$SRC" -name '*.png' \( \
  -path '*/places/folder*'         -o \
  -path '*/places/inode-directory*' -o \
  -path '*/places/user-home*'      -o \
  -path '*/places/user-desktop*'   -o \
  -path '*/places/user-bookmarks*' -o \
  -path '*/actions/folder*'        -o \
  -path '*/status/folder*'         \) -print0)

gtk-update-icon-cache -f -t "$DST" >/dev/null
echo "Recoloured $count icons."

# Optional: keep the icons in sync whenever the Dreaming theme is re-applied.
HOOK_DIR="$HOME/.config/omarchy/hooks/theme-set.d"
mkdir -p "$HOOK_DIR"
cat > "$HOOK_DIR/dreaming-icons" <<EOF
#!/bin/bash
# Rebuild the Yaru-dreaming icon theme if it goes missing when Dreaming is set.
[[ \$1 == dreaming ]] || exit 0
DST="\${XDG_DATA_HOME:-\$HOME/.local/share}/icons/Yaru-dreaming"
[[ -f \$DST/index.theme ]] && exit 0
exec "\$HOME/.config/omarchy/themes/dreaming/install-icons.sh"
EOF
chmod +x "$HOOK_DIR/dreaming-icons"

echo
echo "Done. Now run:  omarchy theme set dreaming"
