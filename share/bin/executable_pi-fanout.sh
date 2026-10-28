#!/usr/bin/env bash
#
# pi-fanout.sh - create trial solutions with several Pi coding agent models,
# and commit a chosen trial solution to the main branch.

set -euo pipefail

PROG=$(basename "$0")
PROMPT_FILE='PROMPT.md'
LOG_FILE='PI_FANOUT_LOG.md'
DEFAULT_CREATE_MSG='trial solution'

MODEL_NAMES=(
    'openrouter/anthropic/claude-haiku-5.5'
    'openrouter/minimax/minimax-m2.7'
    'openrouter/deepseek/deepseek-v4.1-flash'
)
MODEL_IDS=(claude minimax deepseek)

usage() {
    cat <<EOF

USAGE:
  $PROG COMMAND OPTIONS

WORKFLOW:
  1. Write a task specification to the PROMPT.md file.
  2. Generate trial solutions with the 'create' command.
  3. Review each trial solution branch.
  4. Repeat steps 1..3 with the --continue option until satisfied.
  5. Merge the best solution into the main branch with the 'apply' command.

COMMAND:
  create   Create a trial solution with each model (branch pi/<model-id>).
  apply    Commit a trial solution (pi/<model-id>) to the main branch.

OPTIONS:
  -h, --help                   Show this help and exit.
  -n, --dry-run                Print the commands without executing them.
  -m, --commit-message <msg>   Commit message. Mandatory for apply; optional
                               for create (default: "$DEFAULT_CREATE_MSG").
  -c, --continue               Pass --continue to pi (create only, optional).
  -i, --id <model-id>          Model ID. May be repeated with create to
                               process only the given models; mandatory
                               for apply (exactly once).

Model IDs:   ${MODEL_IDS[*]}
Model names: ${MODEL_NAMES[*]}
EOF
}

die() {
    echo "$PROG: error: $*" >&2
    exit 2
}

# Print the index of model ID $1 in MODEL_IDS; return 1 if unknown.
model_index() {
    local i
    for i in "${!MODEL_IDS[@]}"; do
        if [[ ${MODEL_IDS[i]} == "$1" ]]; then
            echo "$i"
            return 0
        fi
    done
    return 1
}

# Execute a command, or print it (shell-quoted) in dry-run mode.
run() {
    if [[ $dry_run == true ]]; then
        printf '%q ' "$@"
        printf '\n'
    else
        "$@"
    fi
}

# Append a Markdown header and the PROMPT.md contents to the log file.
append_log() {
    local id=$1 model=$2 header
    header="## $(date '+%Y-%m-%d %H:%M'): $id: $model: $commit_msg"

    if [[ $dry_run == true ]]; then
        echo "Would append to $LOG_FILE:"
        echo
        echo "$header"
        echo "<contents of $PROMPT_FILE>"
        echo
    else
        {
            echo
            echo "$header"
            echo
            cat "$PROMPT_FILE"
        } >>"$LOG_FILE"
    fi
}

create_trial() {
    local id=$1 idx model start elapsed pi_cmd
    idx=$(model_index "$id")
    model=${MODEL_NAMES[idx]}

    echo "----------------------------------------"
    echo "$id: Generating trial solution..."
    echo "----------------------------------------"
    echo
    append_log "$id" "$model"
    start=$SECONDS
    pi_cmd=(pi)
    if [[ $continue_run == true ]]; then
        pi_cmd+=(--continue)
    fi
    pi_cmd+=(--name "$id" --print --model "$model" "@$PROMPT_FILE")
    run "${pi_cmd[@]}"
    elapsed=$((SECONDS - start))

    run git switch -C "pi/$id"
    run git add -A
    run git commit -m "$id: $commit_msg"
    run git switch main

    echo
    printf '%s: Time taken: %d:%02d\n' "$id" $((elapsed / 60)) $((elapsed % 60))
    echo
}

apply_trial() {
    local id=$1

    echo "----------------------------------------"
    echo "$id: Merging trial solution..."
    echo "----------------------------------------"
    echo
    run git switch main
    run git merge --squash "pi/$id"
    run git commit -m "$commit_msg"
}

# ---------------------------------------------------------------------------
# Parse arguments
# ---------------------------------------------------------------------------

command=''
commit_msg=''
have_msg=false
dry_run=false
continue_run=false
ids=()

if [[ $# -eq 0 ]]; then
    usage >&2
    exit 2
fi

while [[ $# -gt 0 ]]; do
    case $1 in
    -h | --help)
        usage
        exit 0
        ;;
    -n | --dry-run)
        dry_run=true
        ;;
    -m | --commit-message)
        [[ $# -ge 2 ]] || die "option $1 requires an argument"
        commit_msg=$2
        have_msg=true
        shift
        ;;
    -c | --continue)
        continue_run=true
        ;;
    -i | --id)
        [[ $# -ge 2 ]] || die "option $1 requires an argument"
        ids+=("$2")
        shift
        ;;
    -*)
        die "unknown option: $1"
        ;;
    *)
        [[ -z $command ]] || die "unexpected argument: $1"
        command=$1
        ;;
    esac
    shift
done

# ---------------------------------------------------------------------------
# Validate arguments
# ---------------------------------------------------------------------------

case $command in
create | apply) ;;
'') die "missing COMMAND (create or apply)" ;;
*) die "unknown COMMAND: $command (expected create or apply)" ;;
esac

if [[ $have_msg == true && -z $commit_msg ]]; then
    die "-m, --commit-message <commit-message> must not be empty"
fi

if [[ $continue_run == true && $command != create ]]; then
    die "-c, --continue is only valid with the create command"
fi

for id in ${ids[@]+"${ids[@]}"}; do
    model_index "$id" >/dev/null || die "unknown model ID: $id (valid: ${MODEL_IDS[*]})"
done

case $command in
create)
    [[ $have_msg == true ]] || commit_msg=$DEFAULT_CREATE_MSG
    ;;
apply)
    [[ $have_msg == true ]] || die "apply requires the -m, --commit-message <commit-message> option"
    case ${#ids[@]} in
    0) die "apply requires the -i, --id <model-id> option" ;;
    1) ;;
    *) die "apply accepts exactly one -i, --id <model-id> option" ;;
    esac
    ;;
esac

# ---------------------------------------------------------------------------
# Run
# ---------------------------------------------------------------------------

# Work from the top of the Git repository so that @PROMPT.md and the Git
# commands always refer to the same project.
cd "$(git rev-parse --show-toplevel)"

case $command in
create)
    if [[ ${#ids[@]} -gt 0 ]]; then
        selected=("${ids[@]}")
    else
        selected=("${MODEL_IDS[@]}")
    fi
    for id in "${selected[@]}"; do
        create_trial "$id"
    done
    ;;
apply)
    apply_trial "${ids[0]}"
    ;;
esac
