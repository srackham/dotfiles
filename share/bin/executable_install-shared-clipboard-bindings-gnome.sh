#!/usr/bin/env bash
#
# install-clipboard-keybindings.sh
#
# Installs two GNOME custom keyboard shortcuts (overwriting any existing
# custom keybindings list):
#   custom1: Alt+Super+C -> /home/srackham/share/bin/shared-clipboard.sh copy
#   custom2: Alt+Super+V -> /home/srackham/share/bin/shared-clipboard.sh paste

set -euo pipefail

BASE_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"
SCHEMA="org.gnome.settings-daemon.plugins.media-keys"
BINDING_SCHEMA="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding"
SCRIPT="/home/srackham/share/bin/shared-clipboard.sh"

if ! command -v gsettings >/dev/null 2>&1; then
    echo "Error: gsettings not found. This script requires GNOME." >&2
    exit 1
fi

# 1. Overwrite the custom-keybindings list with custom0, custom1, and custom2
gsettings set "$SCHEMA" custom-keybindings \
  "['${BASE_PATH}/custom0/', '${BASE_PATH}/custom1/', '${BASE_PATH}/custom2/']"

# 2. custom1: copy, bound to Alt+Super+C
gsettings set "${BINDING_SCHEMA}:${BASE_PATH}/custom1/" name 'shared-clipboard-copy'
gsettings set "${BINDING_SCHEMA}:${BASE_PATH}/custom1/" command "${SCRIPT} copy"
gsettings set "${BINDING_SCHEMA}:${BASE_PATH}/custom1/" binding '<Alt><Super>c'

# 3. custom2: paste, bound to Alt+Super+V
gsettings set "${BINDING_SCHEMA}:${BASE_PATH}/custom2/" name 'shared-clipboard-paste'
gsettings set "${BINDING_SCHEMA}:${BASE_PATH}/custom2/" command "${SCRIPT} paste"
gsettings set "${BINDING_SCHEMA}:${BASE_PATH}/custom2/" binding '<Alt><Super>v'

# 4. custom0: wezterm, bound to Super+T
gsettings set "${BINDING_SCHEMA}:${BASE_PATH}/custom0/" name 'wezterm'
gsettings set "${BINDING_SCHEMA}:${BASE_PATH}/custom0/" command 'wezterm start --always-new-process'
gsettings set "${BINDING_SCHEMA}:${BASE_PATH}/custom0/" binding '<Super>t'

echo "Installed keybindings:"
echo "  Super+T    -> wezterm start --always-new-process (custom0)"
echo "  Alt+Super+C -> ${SCRIPT} copy   (custom1)"
echo "  Alt+Super+V -> ${SCRIPT} paste  (custom2)"

if [ ! -x "$SCRIPT" ]; then
    echo "Warning: ${SCRIPT} is not executable or does not exist." >&2
    echo "  Run: chmod +x ${SCRIPT}" >&2
fi
