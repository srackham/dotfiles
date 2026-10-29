#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=false

# Parse options
while [[ $# -gt 0 ]]; do
    case "$1" in
    -n | --dry-run)
        DRY_RUN=true
        shift
        ;;
    -*)
        echo "❌ Unknown option: $1" >&2
        echo "Usage: $0 [-n|--dry-run] \"<task_prompt>\" <model1> <model2> [...]"
        exit 1
        ;;
    *)
        break
        ;;
    esac
done

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 [-n|--dry-run] \"<task_prompt>\" <model1> <model2> [...]"
    echo "Example: $0 -n \"Fix memory leak in worker.rs\" anthropic/claude-3-5-sonnet openai/gpt-4o"
    exit 1
fi

TASK="$1"
shift
MODELS=("$@")

TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
WORKTREES=()

if [ "$DRY_RUN" = true ]; then
    echo "🔍 [DRY RUN MODE] Simulating Pi model race..."
else
    echo "🏁 Starting Pi model race for task: \"$TASK\""
fi

echo "Competing models: ${MODELS[*]}"
echo "=================================================="

PIDS=()
for model in "${MODELS[@]}"; do
    safe_model=$(echo "$model" | tr '/' '_')
    wt_dir="../wt_race_${safe_model}_${TIMESTAMP}"
    branch_name="race/${safe_model}-${TIMESTAMP}"

    WORKTREES+=("$wt_dir")

    if [ "$DRY_RUN" = true ]; then
        echo "  [DRY RUN] Would create worktree at '$wt_dir' on branch '$branch_name'"
        echo "  [DRY RUN] Would run: pi --model \"$model\" --prompt \"$TASK\" --non-interactive (inside $wt_dir)"
    else
        echo "🚀 Spawning worktree for [$model] at $wt_dir..."
        git worktree add -b "$branch_name" "$wt_dir" HEAD >/dev/null 2>&1

        (
            cd "$wt_dir"
            echo "⚡ [$model] Agent executing..."
            pi --model "$model" --prompt "$TASK" --non-interactive
            echo "✨ [$model] Completed execution."
        ) &
        PIDS+=($!)
    fi
done

if [ "$DRY_RUN" = true ]; then
    echo "=================================================="
    echo "🔍 Dry run complete. No changes were made."
    exit 0
fi

echo "⏳ Waiting for all model agents to finish coding..."
for pid in "${PIDS[@]}"; do
    wait "$pid" || true
done

echo "=================================================="
echo "🏆 RACE COMPLETE! REVIEW, MERGE, & CLEANUP INSTRUCTIONS:"
echo "--------------------------------------------------"

for i in "${!MODELS[@]}"; do
    model="${MODELS[$i]}"
    wt="${WORKTREES[$i]}"
    safe_model=$(echo "$model" | tr '/' '_')
    branch="race/${safe_model}-${TIMESTAMP}"

    echo ""
    echo "🔹 Model: $model"
    echo "   ├── Worktree: $wt"
    echo "   ├── Branch:   $branch"
    echo "   ├── Quick Diff Preview:"
    (cd "$wt" && git diff main 2>/dev/null || git diff master 2>/dev/null || git diff HEAD~1) | head -n 20 | sed 's/^/   │   /'
    echo "   │   ..."
    echo "   └── To accept this solution:"
    echo "       git merge $branch"
    echo "       git worktree remove --force $wt"
done

echo "=================================================="
echo "🧹 To clean up all unused race worktrees when finished:"
for wt in "${WORKTREES[@]}"; do
    echo "   git worktree remove --force $wt"
done
echo "=================================================="
