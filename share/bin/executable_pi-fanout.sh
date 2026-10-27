#!/usr/bin/env bash
#
# pi-fanout.sh - create trial solutions with several Pi coding agent models,
# and commit a chosen trial solution to the main branch.
#
# Synopsis: pi-fanout.sh COMMAND OPTIONS
#
#   COMMAND
#     create   Create a trial solution with each model (or only the models
#              given with -i) on branch pi/<model-id>.
#     apply    Squash-merge pi/<model-id> into main and commit it.
#
#   OPTIONS
#     -h, --help                   Show help and exit.
#     -n, --dry-run                Print the commands without executing them.
#     -m, --commit-message <msg>   Commit message. Mandatory for apply; optional
#                                  for create (defaults to "trial solution").
#     -i, --id <model-id>          Model ID. May be repeated with create to
#                                  process only the given models; mandatory
#                                  (exactly once) for apply.

set -euo pipefail

PROG=$(basename "$0")
PROMPT_FILE='PROMPT.md'
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
  4. Merge the best solution into the main branch with the 'apply' command.

COMMAND:
  create   Create a trial solution with each model (branch pi/<model-id>).
  apply    Commit a trial solution (pi/<model-id>) to the main branch.

OPTIONS:
  -h, --help                   Show this help and exit.
  -n, --dry-run                Print the commands without executing them.
  -m, --commit-message <msg>   Commit message. Mandatory for apply; optional
                               for create (default: "$DEFAULT_CREATE_MSG").
  -i, --id <model-id>          Model ID. May be repeated with create to
                               process only the given models; mandatory
                               (exactly once) for apply.

Model IDs: ${MODEL_IDS[*]}
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

create_trial() {
    local id=$1 idx model start elapsed
    idx=$(model_index "$id")
    model=${MODEL_NAMES[idx]}

    echo "----------------------------------------"
    echo "$id: Generating trial solution..."
    echo "----------------------------------------"
    echo
    start=$SECONDS
    run pi --name "$id" --print --model "$model" "@$PROMPT_FILE"
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
