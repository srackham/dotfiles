#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status or in a pipeline
set -e
set -o pipefail

# Import shell aliases
shopt -s expand_aliases
source "$HOME/.bashrc"

# --- Configuration and Styling ---

# ANSI Color Codes
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Map of available options (Key: Description). The keys define the fixed execution order.
declare -A ACTIONS
ACTIONS=(
    [C]="Chezmoi dot files"
    [L]="Lazyvim plugins"
    [O]="Other applications"
    [G]="GNOME keyboard shortcuts"
    [B]="Build and activate NixOS"
    [U]="Update and optimise NixOS"
)

# String of valid action keys (e.g., CLOGBU)
VALID_KEYS=$(echo "${!ACTIONS[@]}" | tr ' ' '|')
ALL_KEY="A" # Key used for selecting all actions

# --- Action Functions (Placeholders) ---

do_chezmoi() {
    echo -e "\n${CYAN}--- Running Chezmoi dot files update ---${NC}"
    chezmoi apply
}

do_lazyvim() {
    echo -e "\n${CYAN}--- Running Lazyvim plugins update ---${NC}"
    nvim --headless -c "Lazy! sync" -c "qa"
}

do_other() {
    echo -e "\n${CYAN}--- Running other applications update ---${NC}"
    npm i -g opencode-ai@latest
    npm install -g @google/gemini-cli
    go install github.com/charmbracelet/crush@latest
}

do_gnome() {
    echo -e "\n${CYAN}--- Running GNOME keyboard shortcuts update ---${NC}"
    local chezmoi_repo_dir="$HOME/share/projects/chezmoi"
    dconf load /org/gnome/desktop/wm/keybindings/ <"$chezmoi_repo_dir/exported/wm-keybindings.dconf"
    dconf load /org/gnome/settings-daemon/plugins/media-keys/ <"$chezmoi_repo_dir/exported/media-keys-keybindings.dconf"
    dconf load /org/gnome/shell/keybindings/ <"$chezmoi_repo_dir/exported/shell-keybindings.dconf"
}

do_nixos_build() {
    echo -e "\n${CYAN}--- Running Build and Activate NixOS ---${NC}"
    mknixos switch
}

do_nixos_update() {
    echo -e "\n${CYAN}--- Running Update and Optimise NixOS ---${NC}"
    upgrade-nixos
}

# --- Main Logic ---

display_menu() {
    echo ""
    echo -e "Select from the following update choices:"
    echo ""
    # Display menu options with the first letter highlighted
    for key in C L O G B U; do
        desc="${ACTIONS[$key]}"
        highlighted_desc="${YELLOW}${key}${NC}${desc:1}"
        echo -e "- ${highlighted_desc}"
    done
    echo ""
    # Updated prompt to include the 'A' (All) option
    echo -n "Enter selection [${VALID_KEYS//|/} or ${ALL_KEY} (All)]: "
}

validate_input() {
    local input="$1"
    local invalid_chars=""
    local valid_options="${VALID_KEYS//|/}" # CLOGBU

    # 1. Convert input to uppercase
    input=$(echo "$input" | tr '[:lower:]' '[:upper:]')

    # 2. Check for the 'All' option
    if [[ "$input" =~ $ALL_KEY ]]; then
        # If 'A' is present, filter it out before checking other characters
        chars_to_validate=$(echo "$input" | tr -d "$ALL_KEY" | grep -o .)
    else
        chars_to_validate=$(echo "$input" | grep -o .)
    fi

    # 3. Check for invalid characters among the input (excluding 'A')
    for char in $chars_to_validate; do
        # Checks if the character is NOT present in the list of valid keys
        if [[ ! "$valid_options" =~ $char ]]; then
            invalid_chars+="$char"
        fi
    done

    if [[ -n "$invalid_chars" ]]; then
        # Print error and return 1. The calling function will check this status.
        echo -e "\n${YELLOW}Error:${NC} Invalid characters detected: ${invalid_chars}"
        return 1
    fi

    # 4. Return the final selection string (all keys if 'A' was present)
    if [[ "$input" =~ $ALL_KEY ]]; then
        echo "$valid_options" # Returns CLOGBU
    else
        echo "$input" # Returns the cleaned input
    fi
    return 0
}

main() {
    local SELECTION

    # Loop until valid input is received or user cancels (by pressing Enter)
    while true; do
        display_menu
        read -r raw_selection

        # If selection is empty, the user wants to cancel
        if [[ -z "$raw_selection" ]]; then
            echo -e "\n${YELLOW}User cancelled.${NC}"
            exit 0
        fi

        # Validate input and capture the cleaned selection string
        if SELECTION=$(validate_input "$raw_selection"); then
            break # Exit loop on successful validation
        fi
        # If validate_input returns 1 (failure), the loop continues and prompts again.
    done

    # List choices and ask for confirmation

    # Fixed execution order used for listing and executing
    EXEC_ORDER="CLOGBU"
    ACTIONS_SELECTED=0

    echo -e "\n${CYAN}You have selected the following actions (in execution order):${NC}\n"

    # List selected actions in execution order
    for key in $(echo "$EXEC_ORDER" | grep -o .); do
        # Check if the validated, cleaned selection string contains the current key
        if [[ "$SELECTION" =~ $key ]]; then
            echo -e "- ${ACTIONS[$key]}"
            ACTIONS_SELECTED=$((ACTIONS_SELECTED + 1))
        fi
    done

    # Prompt for confirmation
    echo ""
    read -r -p "Proceed with ${ACTIONS_SELECTED} update(s)? (y/N): " confirm_selection

    # Check confirmation (case-insensitive check for 'Y')
    confirm_selection=$(echo "$confirm_selection" | tr '[:lower:]' '[:upper:]')

    if [[ "$confirm_selection" != "Y" ]]; then
        echo -e "\n${YELLOW}User cancelled execution.${NC}"
        exit 0
    fi

    # Execution phase
    echo -e "\n${CYAN}Starting execution...${NC}\n"

    ACTIONS_EXECUTED=0

    # Execute actions in the fixed order
    for key in $(echo "$EXEC_ORDER" | grep -o .); do
        if [[ "$SELECTION" =~ $key ]]; then
            case "$key" in
            C) do_chezmoi ;;
            L) do_lazyvim ;;
            O) do_other ;;
            G) do_gnome ;;
            B) do_nixos_build ;;
            U) do_nixos_update ;;
            esac
            ACTIONS_EXECUTED=$((ACTIONS_EXECUTED + 1))
        fi
    done

    echo -e "\n${CYAN}All selected tasks (${ACTIONS_EXECUTED}) completed.${NC}"
}

main "$@"
