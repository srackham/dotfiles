#!/usr/bin/env bash
set -euo pipefail

script_dir=$(
    cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &&
        pwd
)

update_script="$script_dir/omv8-update.sh"

if [[ ! -x $update_script ]]; then
    printf 'Error: %s is not executable\n' "$update_script" >&2
    exit 1
fi

remote_hosts=(nuc2 nuc3)
colors=(red blue)

for i in "${!remote_hosts[@]}"; do
    remote_host=${remote_hosts[$i]}
    color=${colors[$i]}

    printf 'Updating %s with color %s...\n' "$remote_host" "$color"
    "$update_script" "$remote_host" "$color"
done

printf 'All updates completed successfully.\n'
