#!/usr/bin/env bash

set -euo pipefail

show_help() {
    cat << 'EOF'
Usage: openrouter_cost.sh [POLL_MINUTES] [OPTIONS]

Polls OpenRouter usage at a set interval and displays period costs 
and cumulative cost accumulated during the script run.

Arguments:
  POLL_MINUTES              Polling interval in minutes (default: 1). Must be a positive integer.

Options:
  -c, --continuous          Print output every polling interval even if period cost is zero.
  -l, --log-file FILE       File to append cost logs to. Initializes cumulative cost
                            from the last entry if the file exists.
  -r, --reset               Clears/truncates the log file on startup (requires -l/--log-file).
  -h, --help                Show this help message and exit.

Environment Variables:
  OPENROUTER_API_KEY        Required. Your OpenRouter API key.
EOF
}

LOG_FILE=""
POLL_MINUTES=""
RESET_LOG=false
CONTINUOUS=false

# Parse options and positional arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        -c|--continuous)
            CONTINUOUS=true
            shift
            ;;
        -r|--reset)
            RESET_LOG=true
            shift
            ;;
        -l|--log-file)
            if [[ -n "${2:-}" && ! "$2" =~ ^- ]]; then
                LOG_FILE="$2"
                shift 2
            else
                echo "Error: Option '$1' requires a file path argument." >&2
                exit 1
            fi
            ;;
        -l=*|--log-file=*)
            LOG_FILE="${1#*=}"
            shift
            ;;
        *)
            if [[ -z "$POLL_MINUTES" ]]; then
                POLL_MINUTES="$1"
                shift
            else
                echo "Error: Unknown or extra argument '$1'" >&2
                exit 1
            fi
            ;;
    esac
done

# Validate reset flag logic
if [[ "$RESET_LOG" == true && -z "$LOG_FILE" ]]; then
    echo "Error: --reset (-r) requires a log file to be specified with --log-file (-l)." >&2
    exit 1
fi

POLL_MINUTES="${POLL_MINUTES:-1}"

if ! [[ "$POLL_MINUTES" =~ ^[0-9]+$ ]] || [ "$POLL_MINUTES" -le 0 ]; then
    echo "Error: Argument must be a positive integer representing polling interval in minutes." >&2
    exit 1
fi

# Ensure OPENROUTER_API_KEY is set
if [[ -z "${OPENROUTER_API_KEY:-}" ]]; then
    echo "Error: OPENROUTER_API_KEY environment variable is not set." >&2
    exit 1
fi

# Dependency check
for cmd in curl jq sleep date; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: Required command '$cmd' is not installed." >&2
        exit 1
    fi
done

SLEEP_SECONDS=$((POLL_MINUTES * 60))

get_current_usage() {
    local response
    response=$(curl -s -X GET "https://openrouter.ai/api/v1/auth/key" \
        -H "Authorization: Bearer ${OPENROUTER_API_KEY}")

    if echo "$response" | jq -e '.error' >/dev/null 2>&1; then
        echo "API Error:" >&2
        echo "$response" | jq -r '.error.message // .error' >&2
        exit 1
    fi

    echo "$response" | jq -r '.data.usage // 0'
}

# Graceful exit on Ctrl+C (SIGINT/SIGTERM)
trap 'echo -e "\nStopping OpenRouter cost monitor."; exit 0' INT TERM

# Truncate log file if reset flag is present
if [[ "$RESET_LOG" == true && -n "$LOG_FILE" ]]; then
    true > "$LOG_FILE"
fi

# Initialize prior cumulative cost from log file if specified and exists
PRIOR_CUMULATIVE="0.00"
if [[ -n "$LOG_FILE" && -f "$LOG_FILE" ]]; then
    LAST_LINE=$(tail -n 1 "$LOG_FILE" 2>/dev/null || true)
    if [[ -n "$LAST_LINE" ]]; then
        # Parse value following 'Cumulative cost: $'
        EXTRACTED=$(echo "$LAST_LINE" | sed -n 's/.*Cumulative cost: \$\([0-9.]*\) USD.*/\1/p')
        if [[ -n "$EXTRACTED" ]]; then
            PRIOR_CUMULATIVE="$EXTRACTED"
        fi
    fi
fi

CURRENT_API_USAGE=$(get_current_usage)
PREV_USAGE="$CURRENT_API_USAGE"
# Baseline API usage for session calculations: API Usage - Prior Cumulative Cost
INITIAL_BASELINE=$(jq -n --arg usage "$CURRENT_API_USAGE" --arg prior "$PRIOR_CUMULATIVE" '$usage | tonumber - ($prior | tonumber)')

echo "Starting continuous polling every ${POLL_MINUTES} minute(s)..."

while true; do
    sleep "$SLEEP_SECONDS"

    CURRENT_USAGE=$(get_current_usage)
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

    # Calculate interval cost and cumulative session cost using jq
    COST_DIFF=$(jq -n --arg prev "$PREV_USAGE" --arg curr "$CURRENT_USAGE" '$curr | tonumber - ($prev | tonumber)')
    CUMULATIVE_COST=$(jq -n --arg base "$INITIAL_BASELINE" --arg curr "$CURRENT_USAGE" '$curr | tonumber - ($base | tonumber)')

    # Check if cost > 0
    IS_NON_ZERO=$(jq -n --arg cost "$COST_DIFF" '$cost | tonumber > 0')

    # Print if continuous flag is set OR cost is non-zero
    if [[ "$CONTINUOUS" == true ]] || [[ "$IS_NON_ZERO" == "true" ]]; then
        OUTPUT_MSG=$(printf "[%s] Cost past %d min: \$%.2f USD | Cumulative cost: \$%.2f USD" \
            "$TIMESTAMP" "$POLL_MINUTES" "$COST_DIFF" "$CUMULATIVE_COST")
        
        echo "$OUTPUT_MSG"

        if [[ -n "$LOG_FILE" ]]; then
            echo "$OUTPUT_MSG" >> "$LOG_FILE"
        fi
    fi

    PREV_USAGE="$CURRENT_USAGE"
done
