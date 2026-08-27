#!/bin/bash
# Wires GTK apps (Nautilus etc.) into the Dreaming palette. Run this once after
# `omarchy theme install`, then run `omarchy theme set dreaming`.
#
# Omarchy has no GTK theming of its own and won't run scripts from an installed
# theme, so this is a one-time manual step -- same as install-icons.sh.
#
# What it does:
#   - points ~/.config/gtk-3.0/gtk.css and ~/.config/gtk-4.0/gtk.css at the
#     staged file ~/.local/state/omarchy/current/theme/gtk.css (which
#     `omarchy theme set` refreshes from whichever theme is active)
#   - installs a theme-set hook that restarts Nautilus when Dreaming is applied

set -euo pipefail

STAGED="$HOME/.local/state/omarchy/current/theme/gtk.css"
MARKER="/* dreaming: import omarchy current-theme gtk.css */"

link_gtk() {
  local dir="$HOME/.config/$1"
  local file="$dir/gtk.css"

  mkdir -p "$dir"

  if [[ -f $file ]] && ! grep -qF "$MARKER" "$file"; then
    cp "$file" "$file.pre-dreaming.bak"
    echo "Backed up existing $file -> $file.pre-dreaming.bak"
  fi

  # @import must be the first rule in the file
  cat > "$file" <<EOF
$MARKER
@import url("file://$STAGED");
EOF
  echo "Wrote $file"
}

link_gtk gtk-3.0
link_gtk gtk-4.0

# Restart Nautilus on future `omarchy theme set dreaming` so it re-reads gtk.css.
HOOK_DIR="$HOME/.config/omarchy/hooks/theme-set.d"
mkdir -p "$HOOK_DIR"
cat > "$HOOK_DIR/dreaming-gtk" <<'EOF'
#!/bin/bash
# Restart GTK file managers when Dreaming is applied so they pick up gtk.css.
[[ $1 == dreaming ]] || exit 0
command -v nautilus >/dev/null && nautilus -q 2>/dev/null || true
EOF
chmod +x "$HOOK_DIR/dreaming-gtk"
echo "Installed theme-set hook: $HOOK_DIR/dreaming-gtk"

echo
echo "Done. Now run:  omarchy theme set dreaming"
echo "(then reopen Nautilus)"
