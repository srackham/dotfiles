#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 \"<task_prompt>\" <model1> <model2> [...]"
    echo "Example: $0 \"Fix the memory leak in worker.rs\" sonnet gpt-4o"
    exit 1
fi

TASK="$1"
shift
MODELS=("$@")

TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
WORKTREES=()

echo "🏁 Starting Pi model race for task: \"$TASK\""
echo "Competing models: ${MODELS[*]}"
echo "=================================================="

PIDS=()
for model in "${MODELS[@]}"; do
    # Sanitize model name for directory and branch naming
    safe_model=$(echo "$model" | tr '/' '_')
    wt_dir="../wt_race_${safe_model}_${TIMESTAMP}"
    branch_name="race/${safe_model}-${TIMESTAMP}"

    WORKTREES+=("$wt_dir")

    echo "🚀 Spawning worktree for [$model] at $wt_dir..."
    git worktree add -b "$branch_name" "$wt_dir" HEAD >/dev/null 2>&1

    # Launch pi agent in the background inside its isolated worktree
    (
        cd "$wt_dir"
        echo "⚡ [$model] Agent executing..."
        # Pass your task to pi in non-interactive/automated mode
        pi --model "$model" --prompt "$TASK" --non-interactive
        echo "✨ [$model] Completed execution."
    ) &
    PIDS+=($!)
done

echo "⏳ Waiting for all model agents to finish coding..."
for pid in "${PIDS[@]}"; do
    wait "$pid" || true
done

echo "=================================================="
echo "✅ Race complete! Isolated branches and diffs ready for review:"
for i in "${!MODELS[@]}"; do
    model="${MODELS[$i]}"
    wt="${WORKTREES[$i]}"
    safe_model=$(echo "$model" | tr '/' '_')
    branch="race/${safe_model}-${TIMESTAMP}"

    echo ""
    echo "🔹 Model: $model"
    echo "   Branch: $branch"
    echo "   Worktree path: $wt"
    echo "   Quick diff check:"
    (cd "$wt" && git diff main 2>/dev/null || git diff master 2>/dev/null || git diff HEAD~1) | head -n 30
    echo "   ..."
done
echo "=================================================="
echo "To merge the winner: cd <worktree_path> or merge branch directly into your main branch."
