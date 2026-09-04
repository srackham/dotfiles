#!/usr/bin/env bash
#
# install-clipboard-keybindings-omarchy.sh
#
# Installs two custom Hyprland keybindings in Omarchy Quattro (v4) Linux,
# which configures Hyprland via Lua (overwrites any existing bindings for
# the same key combos):
#   custom1: Alt+Super+C -> /home/srackham/share/bin/shared-clipboard.sh copy
#   custom2: Alt+Super+V -> /home/srackham/share/bin/shared-clipboard.sh paste
#
# Quattro stores user keybindings in ~/.config/hypr/bindings.lua, using the
# o.bind(keys, label, command) / hl.unbind(keys) Lua API (Hyprland has no
# GNOME-style named "custom command" registry, so custom1/custom2 are kept
# only as comment labels for traceability).

set -euo pipefail

BINDINGS_FILE="${HOME}/.config/hypr/bindings.lua"
SCRIPT="/home/srackham/share/bin/shared-clipboard.sh"

if [ ! -f "$BINDINGS_FILE" ]; then
    echo "Error: ${BINDINGS_FILE} not found. Is this an Omarchy Quattro system?" >&2
    exit 1
fi

# Back up the file before modifying it
cp "$BINDINGS_FILE" "${BINDINGS_FILE}.bak.$(date +%Y%m%d%H%M%S)"

# Remove any previous custom1/custom2 blocks this script may have added,
# so re-running it overwrites rather than duplicates them.
sed -i '/-- custom1: shared-clipboard-copy/,+2d' "$BINDINGS_FILE"
sed -i '/-- custom2: shared-clipboard-paste/,+2d' "$BINDINGS_FILE"

# Append the new bindings. hl.unbind() first clears any pre-existing bind
# on these key combos so o.bind() cleanly overwrites them.
cat >>"$BINDINGS_FILE" <<EOF

-- custom1: shared-clipboard-copy
hl.unbind("ALT + SUPER + C")
o.bind("ALT + SUPER + C", "Shared clipboard copy", "${SCRIPT} copy")

-- custom2: shared-clipboard-paste
hl.unbind("ALT + SUPER + V")
o.bind("ALT + SUPER + V", "Shared clipboard paste", "${SCRIPT} paste")
EOF

echo "Installed keybindings in ${BINDINGS_FILE}:"
echo "  Alt+Super+C -> ${SCRIPT} copy   (custom1)"
echo "  Alt+Super+V -> ${SCRIPT} paste  (custom2)"

if [ ! -x "$SCRIPT" ]; then
    echo "Warning: ${SCRIPT} is not executable or does not exist." >&2
    echo "  Run: chmod +x ${SCRIPT}" >&2
fi

# Reload Hyprland so the new bindings take effect immediately
if command -v hyprctl >/dev/null 2>&1; then
    hyprctl reload
    echo "Hyprland config reloaded."
else
    echo "Note: hyprctl not found; reload Hyprland manually to apply changes." >&2
fi
