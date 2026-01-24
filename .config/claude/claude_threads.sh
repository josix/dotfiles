#!/usr/bin/env bash
# claude_threads.sh - Thread-based engineering toolkit for Claude Code CLI
# Source this file from ~/.bashrc or ~/.zshrc
#
# Provides execution modes ("threads"):
#   B0: Base thread - one prompt -> agent run -> review
#   P:  Parallel threads - N concurrent runs
#   C:  Chained threads - multi-phase with checkpoints
#   F:  Fusion threads - N candidates merged into one
#   B:  Big/meta threads - top-level with subagent delegation
#   L:  Long duration - validation loop
#   Z:  Zero-touch-ish - fail-closed autopilot with gating
#
# Compatible with bash 4+ and zsh 5+

# ==============================================================================
# CONFIGURATION DEFAULTS (override via environment variables)
# ==============================================================================

: "${CC_MODEL:=opus}"
: "${CC_OUTFMT:=text}"
: "${CC_THREADS_DIR:=${XDG_STATE_HOME:-$HOME/.local/state}/cc-threads}"
: "${CC_MAX_TURNS:=0}"
: "${CC_VALIDATE_CMD:=}"

# ==============================================================================
# INTERNAL UTILITIES
# ==============================================================================

_cc_check_claude() {
    if ! command -v claude >/dev/null 2>&1; then
        printf '%s\n' "ERROR: 'claude' CLI not found in PATH" >&2
        return 1
    fi
    return 0
}

_cc_timestamp() {
    date +"%Y%m%d_%H%M%S"
}

_cc_uuid() {
    # Portable UUID generation: try multiple methods
    if command -v uuidgen >/dev/null 2>&1; then
        uuidgen | tr '[:upper:]' '[:lower:]'
    elif [ -r /proc/sys/kernel/random/uuid ]; then
        cat /proc/sys/kernel/random/uuid
    elif command -v python3 >/dev/null 2>&1; then
        python3 -c 'import uuid; print(uuid.uuid4())'
    elif command -v python >/dev/null 2>&1; then
        python -c 'import uuid; print(uuid.uuid4())'
    else
        # Fallback: timestamp + random
        printf '%s-%04x%04x-%04x-%04x\n' \
            "$(_cc_timestamp)" \
            "$RANDOM" "$RANDOM" "$RANDOM" "$RANDOM"
    fi
}

_cc_ensure_threads_dir() {
    if [ ! -d "$CC_THREADS_DIR" ]; then
        mkdir -p "$CC_THREADS_DIR" || {
            printf '%s\n' "ERROR: Cannot create threads directory: $CC_THREADS_DIR" >&2
            return 1
        }
    fi
    return 0
}

_cc_model_args() {
    local args=()
    args+=(--model "$CC_MODEL")
    if [ "$CC_MAX_TURNS" -gt 0 ] 2>/dev/null; then
        args+=(--max-turns "$CC_MAX_TURNS")
    fi
    printf '%s\n' "${args[@]}"
}

_cc_print_args() {
    local args=()
    args+=(--output-format "$CC_OUTFMT")
    printf '%s\n' "${args[@]}"
}

_cc_log() {
    printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

_cc_hr() {
    printf '%s\n' "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# ==============================================================================
# A) BASE WRAPPERS
# ==============================================================================

# cc - Interactive Claude REPL wrapper
cc() {
    _cc_check_claude || return 1
    local model_args
    model_args=($(_cc_model_args))
    claude "${model_args[@]}" "$@"
}

# ccp - Print mode wrapper (script-friendly, non-interactive)
ccp() {
    _cc_check_claude || return 1
    if [ $# -eq 0 ]; then
        printf '%s\n' "Usage: ccp <prompt> [claude args...]" >&2
        return 1
    fi
    local prompt="$1"
    shift
    local model_args print_args
    model_args=($(_cc_model_args))
    print_args=($(_cc_print_args))
    claude "${model_args[@]}" "${print_args[@]}" --print "$prompt" "$@"
}

# ==============================================================================
# A2) APPROVAL MODE WRAPPERS
# ==============================================================================

# cc_plan - Plan mode: Claude presents plan, you approve before execution
# Usage: cc_plan "task description"
cc_plan() {
    _cc_check_claude || return 1
    local model_args
    model_args=($(_cc_model_args))
    claude "${model_args[@]}" --permission-mode plan "$@"
}

# cc_step - Step-by-step approval: explicit permission prompt for each action
# This is the default Claude behavior, but named explicitly for clarity
# Usage: cc_step "task description"
cc_step() {
    _cc_check_claude || return 1
    local model_args
    model_args=($(_cc_model_args))
    # Default mode already prompts for each action
    claude "${model_args[@]}" "$@"
}

# cc_approve - Interactive approval with action preview
# Runs with explicit tool restrictions and prompts for each step
# Usage: cc_approve "task description" [allowed_tools...]
cc_approve() {
    _cc_check_claude || return 1

    if [ $# -eq 0 ]; then
        printf '%s\n' "Usage: cc_approve \"<task>\" [tool1,tool2,...]" >&2
        return 1
    fi

    local task="$1"
    shift

    local model_args
    model_args=($(_cc_model_args))

    # If tools specified, restrict to those
    if [ $# -gt 0 ]; then
        local tools="$1"
        shift
        claude "${model_args[@]}" --allowedTools "$tools" "$@" "$task"
    else
        # Default: allow safe read-only tools, prompt for writes
        claude "${model_args[@]}" "$@" "$task"
    fi
}

# cc_readonly - Read-only mode: only allow non-modifying tools
# Usage: cc_readonly "question or analysis task"
cc_readonly() {
    _cc_check_claude || return 1

    if [ $# -eq 0 ]; then
        printf '%s\n' "Usage: cc_readonly \"<task>\"" >&2
        return 1
    fi

    local task="$1"
    shift

    local model_args
    model_args=($(_cc_model_args))

    # Only allow read operations
    claude "${model_args[@]}" \
        --allowedTools "Read,Glob,Grep,WebSearch,WebFetch,Task" \
        "$@" "$task"
}

# cc_yolo - Skip all permission prompts (use with caution!)
# Usage: cc_yolo "trusted task"
cc_yolo() {
    _cc_check_claude || return 1

    if [ $# -eq 0 ]; then
        printf '%s\n' "Usage: cc_yolo \"<task>\"" >&2
        printf '%s\n' "WARNING: This skips all permission prompts!" >&2
        return 1
    fi

    local task="$1"
    shift

    local model_args
    model_args=($(_cc_model_args))

    printf '%s\n' "WARNING: Running with --dangerously-skip-permissions" >&2
    claude "${model_args[@]}" --dangerously-skip-permissions "$@" "$task"
}

# ccp_plan - Print mode with plan: show what would be done, then execute
# Usage: ccp_plan "task"
ccp_plan() {
    _cc_check_claude || return 1

    if [ $# -eq 0 ]; then
        printf '%s\n' "Usage: ccp_plan \"<task>\"" >&2
        return 1
    fi

    local task="$1"
    shift

    local model_args print_args
    model_args=($(_cc_model_args))
    print_args=($(_cc_print_args))

    # First, get the plan
    _cc_log "Generating execution plan..."
    _cc_hr

    local plan_prompt="Create a detailed step-by-step plan for this task. DO NOT execute anything yet, just outline what you would do:

$task

Format as numbered steps with expected outcomes."

    claude "${model_args[@]}" "${print_args[@]}" --print "$plan_prompt" "$@"

    local plan_exit=$?

    _cc_hr
    printf '%s' "Review the plan above. Execute it? [y/N]: "
    read -r response

    case "$response" in
        [yY]|[yY][eE][sS])
            _cc_log "Executing plan..."
            _cc_hr
            claude "${model_args[@]}" "${print_args[@]}" \
                --continue --print "Now execute the plan step by step. After each step, report what was done." \
                "$@"
            ;;
        *)
            _cc_log "Execution cancelled by user"
            return 130
            ;;
    esac
}

# cc_confirm - Run with confirmation prompts between major actions
# Uses a phased approach: plan -> confirm -> execute -> confirm -> next
# Usage: cc_confirm "complex task"
cc_confirm() {
    _cc_check_claude || return 1
    _cc_ensure_threads_dir || return 1

    if [ $# -eq 0 ]; then
        printf '%s\n' "Usage: cc_confirm \"<task>\"" >&2
        return 1
    fi

    local task="$1"
    shift

    local run_dir="${CC_THREADS_DIR}/$(_cc_timestamp)_confirm"
    mkdir -p "$run_dir" || return 1

    local model_args print_args
    model_args=($(_cc_model_args))
    print_args=($(_cc_print_args))

    _cc_log "CONFIRM MODE: Step-by-step execution with approval"
    _cc_log "Task: $task"
    _cc_hr

    # Phase 1: Get the plan
    _cc_log "Phase 1: Generating plan..."
    local plan_prompt="Analyze this task and create a detailed execution plan. List each action you would take, in order. DO NOT execute anything yet.

Task: $task

Format:
1. [Action]: Description and expected outcome
2. [Action]: Description and expected outcome
..."

    claude "${model_args[@]}" "${print_args[@]}" \
        --print "$plan_prompt" \
        "$@" \
        2>&1 | tee "${run_dir}/plan.txt"

    _cc_hr
    printf '%s' "Approve this plan? [y/N/e(dit)]: "
    read -r response

    case "$response" in
        [eE]|[eE][dD][iI][tT])
            printf '%s\n' "Enter modified instructions (Ctrl+D when done):"
            local modified_task
            modified_task=$(cat)
            task="$modified_task"
            ;;
        [yY]|[yY][eE][sS])
            ;;
        *)
            _cc_log "Cancelled by user"
            return 130
            ;;
    esac

    # Phase 2: Execute with step confirmations
    _cc_log "Phase 2: Executing with step confirmations..."

    local step_prompt="Execute the plan for this task ONE STEP AT A TIME.

After completing each step:
1. Report exactly what you did
2. Show any output or changes
3. STOP and wait for approval before the next step

Task: $task

Begin with step 1 only."

    local step=1
    while true; do
        _cc_hr
        _cc_log "Executing step $step..."

        if [ $step -eq 1 ]; then
            claude "${model_args[@]}" "${print_args[@]}" \
                --print "$step_prompt" \
                "$@" \
                2>&1 | tee "${run_dir}/step_${step}.txt"
        else
            claude "${model_args[@]}" "${print_args[@]}" \
                --continue --print "Continue with the next step. Execute ONE step, report what you did, then STOP." \
                "$@" \
                2>&1 | tee "${run_dir}/step_${step}.txt"
        fi

        _cc_hr
        printf '%s' "Step $step complete. Continue? [y/N/r(evert)/d(one)]: "
        read -r response

        case "$response" in
            [yY]|[yY][eE][sS])
                step=$((step + 1))
                ;;
            [rR]|[rR][eE][vV][eE][rR][tT])
                _cc_log "Reverting step $step..."
                claude "${model_args[@]}" "${print_args[@]}" \
                    --continue --print "Undo/revert the last action you took. Restore to previous state." \
                    "$@" \
                    2>&1 | tee "${run_dir}/step_${step}_revert.txt"
                ;;
            [dD]|[dD][oO][nN][eE])
                _cc_log "Marked as complete by user"
                break
                ;;
            *)
                _cc_log "Stopping execution"
                break
                ;;
        esac
    done

    _cc_hr
    _cc_log "Confirm mode complete. $step steps executed."
    _cc_log "Logs saved to: $run_dir"
    printf '%s\n' "$run_dir"
}

# ==============================================================================
# B) SESSION HELPERS
# ==============================================================================

# cc_continue - Continue most recent session in current directory
cc_continue() {
    _cc_check_claude || return 1
    local model_args
    model_args=($(_cc_model_args))
    claude "${model_args[@]}" --continue "$@"
}

# cc_resume - Resume session by ID or name (interactive picker if no arg)
cc_resume() {
    _cc_check_claude || return 1
    local model_args
    model_args=($(_cc_model_args))
    if [ $# -eq 0 ]; then
        # No session ID provided - let claude handle picker
        claude "${model_args[@]}" --resume
    else
        local session_id="$1"
        shift
        claude "${model_args[@]}" --resume "$session_id" "$@"
    fi
}

# cc_fork - Fork current session when continuing
cc_fork() {
    _cc_check_claude || return 1
    local model_args
    model_args=($(_cc_model_args))
    # Note: Using --continue with some method to fork
    # Claude Code uses environment or specific flags
    claude "${model_args[@]}" --continue "$@"
}

# ccp_continue - Continue session in print mode (script-friendly)
ccp_continue() {
    _cc_check_claude || return 1
    if [ $# -eq 0 ]; then
        printf '%s\n' "Usage: ccp_continue <prompt> [claude args...]" >&2
        return 1
    fi
    local prompt="$1"
    shift
    local model_args print_args
    model_args=($(_cc_model_args))
    print_args=($(_cc_print_args))
    claude "${model_args[@]}" "${print_args[@]}" --continue --print "$prompt" "$@"
}

# ==============================================================================
# C) P-THREAD: PARALLEL EXECUTION
# ==============================================================================

# cc_pthread - Run N parallel print-mode calls
# Usage: cc_pthread <N> "<prompt>" [extra claude args...]
cc_pthread() {
    _cc_check_claude || return 1
    _cc_ensure_threads_dir || return 1

    if [ $# -lt 2 ]; then
        printf '%s\n' "Usage: cc_pthread <N> \"<prompt>\" [claude args...]" >&2
        return 1
    fi

    local n="$1"
    local prompt="$2"
    shift 2

    if ! [[ "$n" =~ ^[0-9]+$ ]] || [ "$n" -lt 1 ]; then
        printf '%s\n' "ERROR: N must be a positive integer" >&2
        return 1
    fi

    local run_dir="${CC_THREADS_DIR}/$(_cc_timestamp)_pthread"
    mkdir -p "$run_dir" || {
        printf '%s\n' "ERROR: Cannot create run directory: $run_dir" >&2
        return 1
    }

    _cc_log "Starting $n parallel threads..."
    _cc_log "Output directory: $run_dir"
    _cc_hr

    local model_args print_args
    model_args=($(_cc_model_args))
    print_args=($(_cc_print_args))

    local pids=()
    local i
    for i in $(seq 1 "$n"); do
        (
            claude "${model_args[@]}" "${print_args[@]}" \
                --print "$prompt" \
                --dangerously-skip-permissions \
                "$@" \
                >"${run_dir}/out_${i}.txt" 2>"${run_dir}/err_${i}.txt"
        ) &
        pids+=($!)
    done

    # Wait for all background jobs
    local pid exit_codes=()
    for pid in "${pids[@]}"; do
        wait "$pid"
        exit_codes+=($?)
    done

    _cc_hr
    _cc_log "All $n threads completed"
    _cc_hr

    # Print results summary
    for i in $(seq 1 "$n"); do
        printf '\n'
        _cc_log "=== Thread $i (exit: ${exit_codes[$((i-1))]}) ==="
        if [ -s "${run_dir}/out_${i}.txt" ]; then
            cat "${run_dir}/out_${i}.txt"
        else
            printf '%s\n' "(no output)"
        fi
        if [ -s "${run_dir}/err_${i}.txt" ]; then
            printf '%s\n' "--- stderr ---"
            cat "${run_dir}/err_${i}.txt"
        fi
    done

    printf '\n'
    _cc_hr
    _cc_log "Results saved to: $run_dir"
    printf '%s\n' "$run_dir"
}

# ==============================================================================
# D) C-THREAD: CHAINED/PHASED EXECUTION
# ==============================================================================

# cc_cthread - Execute phases from file with checkpoints
# Usage: cc_cthread <phases_file>
cc_cthread() {
    _cc_check_claude || return 1
    _cc_ensure_threads_dir || return 1

    if [ $# -lt 1 ]; then
        printf '%s\n' "Usage: cc_cthread <phases_file>" >&2
        return 1
    fi

    local phases_file="$1"
    if [ ! -r "$phases_file" ]; then
        printf '%s\n' "ERROR: Cannot read phases file: $phases_file" >&2
        return 1
    fi

    local run_dir="${CC_THREADS_DIR}/$(_cc_timestamp)_cthread"
    mkdir -p "$run_dir" || return 1
    local log_file="${run_dir}/execution.log"

    _cc_log "Starting chained execution from: $phases_file" | tee "$log_file"
    _cc_log "Log directory: $run_dir" | tee -a "$log_file"

    local model_args print_args
    model_args=($(_cc_model_args))
    print_args=($(_cc_print_args))

    local phase_num=0
    local line
    while IFS= read -r line || [ -n "$line" ]; do
        # Skip empty lines and comments
        [[ -z "$line" || "$line" =~ ^[#\;] ]] && continue

        phase_num=$((phase_num + 1))
        _cc_hr | tee -a "$log_file"
        _cc_log "Phase $phase_num: $line" | tee -a "$log_file"
        _cc_hr | tee -a "$log_file"

        local phase_out="${run_dir}/phase_${phase_num}.txt"

        # Run phase (continue from previous if not first)
        if [ "$phase_num" -eq 1 ]; then
            claude "${model_args[@]}" "${print_args[@]}" \
                --print "$line" \
                2>&1 | tee "$phase_out" | tee -a "$log_file"
        else
            claude "${model_args[@]}" "${print_args[@]}" \
                --continue --print "$line" \
                2>&1 | tee "$phase_out" | tee -a "$log_file"
        fi

        local exit_code=${PIPESTATUS[0]}
        _cc_log "Phase $phase_num completed (exit: $exit_code)" | tee -a "$log_file"

        # Checkpoint: prompt user before continuing
        printf '\n'
        _cc_hr
        printf '%s' "Phase $phase_num complete. Press Enter to continue or Ctrl+C to stop... "
        read -r || {
            _cc_log "Execution interrupted by user" | tee -a "$log_file"
            return 130
        }
    done < "$phases_file"

    _cc_hr | tee -a "$log_file"
    _cc_log "All $phase_num phases completed" | tee -a "$log_file"
    _cc_log "Results saved to: $run_dir" | tee -a "$log_file"
    printf '%s\n' "$run_dir"
}

# ==============================================================================
# E) F-THREAD: FUSION (N candidates -> synthesize)
# ==============================================================================

# cc_fthread - Generate N candidates then fuse into one
# Usage: cc_fthread <N> "<prompt>" [extra claude args...]
cc_fthread() {
    _cc_check_claude || return 1
    _cc_ensure_threads_dir || return 1

    if [ $# -lt 2 ]; then
        printf '%s\n' "Usage: cc_fthread <N> \"<prompt>\" [claude args...]" >&2
        return 1
    fi

    local n="$1"
    local prompt="$2"
    shift 2

    if ! [[ "$n" =~ ^[0-9]+$ ]] || [ "$n" -lt 2 ]; then
        printf '%s\n' "ERROR: N must be at least 2 for fusion" >&2
        return 1
    fi

    local run_dir="${CC_THREADS_DIR}/$(_cc_timestamp)_fthread"
    mkdir -p "$run_dir" || return 1

    _cc_log "Generating $n candidates for fusion..."
    _cc_log "Output directory: $run_dir"
    _cc_hr

    local model_args print_args
    model_args=($(_cc_model_args))
    print_args=($(_cc_print_args))

    # Generate candidates in parallel
    local pids=()
    local i
    for i in $(seq 1 "$n"); do
        (
            claude "${model_args[@]}" "${print_args[@]}" \
                --print "$prompt" \
                --dangerously-skip-permissions \
                "$@" \
                >"${run_dir}/cand_${i}.txt" 2>"${run_dir}/cand_${i}_err.txt"
        ) &
        pids+=($!)
    done

    for pid in "${pids[@]}"; do
        wait "$pid"
    done

    _cc_log "All $n candidates generated"

    # Build fusion input file
    local fusion_input="${run_dir}/fusion_input.txt"
    {
        printf '%s\n\n' "# FUSION INPUT: $n candidates for prompt:"
        printf '%s\n\n' "> $prompt"
        printf '%s\n\n' "---"

        for i in $(seq 1 "$n"); do
            printf '%s\n' "=== CANDIDATE $i ==="
            if [ -s "${run_dir}/cand_${i}.txt" ]; then
                cat "${run_dir}/cand_${i}.txt"
            else
                printf '%s\n' "(empty or failed)"
            fi
            printf '\n%s\n\n' "=== END CANDIDATE $i ==="
        done
    } > "$fusion_input"

    _cc_hr
    _cc_log "Running fusion synthesis..."

    local fusion_prompt
    fusion_prompt="$(cat <<'FUSION_EOF'
You are a fusion synthesizer. Review all candidates below and create a single, optimal response.

Instructions:
1. Identify the best elements from each candidate
2. Resolve any conflicts or contradictions
3. Synthesize into one coherent, complete answer
4. Add a brief "Fusion Notes" section at the end with:
   - Which candidates contributed what
   - Any risks or assumptions made
   - Confidence level (high/medium/low)

CANDIDATES:
FUSION_EOF
)"
    fusion_prompt="${fusion_prompt}

$(cat "$fusion_input")"

    local fused_output="${run_dir}/fused.txt"
    claude "${model_args[@]}" "${print_args[@]}" \
        --print "$fusion_prompt" \
        --dangerously-skip-permissions \
        > "$fused_output" 2>&1

    _cc_hr
    _cc_log "Fusion complete!"
    printf '\n'
    cat "$fused_output"
    printf '\n'
    _cc_hr
    _cc_log "Fused result saved to: $fused_output"
    _cc_log "All outputs in: $run_dir"
    printf '%s\n' "$fused_output"
}

# ==============================================================================
# F) B-THREAD: BIG/META WITH SUBAGENTS
# ==============================================================================

# cc_bthread - Run interactive task with subagent delegation
# Usage: cc_bthread "<task>"
cc_bthread() {
    _cc_check_claude || return 1

    if [ $# -lt 1 ]; then
        printf '%s\n' "Usage: cc_bthread \"<task>\"" >&2
        return 1
    fi

    local task="$1"
    shift

    # Define subagents JSON
    local agents_json
    agents_json='[
        {
            "name": "code-reviewer",
            "tools": ["Read", "Grep", "Glob", "Bash"],
            "prompt": "You are a security and correctness code reviewer. Analyze code for bugs, security vulnerabilities, and best practice violations. Be thorough but concise."
        },
        {
            "name": "debugger",
            "tools": ["Read", "Grep", "Glob", "Bash"],
            "prompt": "You are a systematic debugger. Investigate issues methodically: reproduce, isolate, identify root cause, suggest fixes. Use scientific method."
        },
        {
            "name": "researcher",
            "tools": ["Read", "Grep", "Glob", "WebSearch", "WebFetch"],
            "prompt": "You are a research agent. Find relevant information, documentation, and examples. Summarize findings clearly with sources."
        }
    ]'

    local system_append
    system_append="You have access to specialized subagents for delegation:
- code-reviewer: For security/correctness review of code
- debugger: For systematic debugging and root cause analysis
- researcher: For finding documentation and examples

Delegate to these agents when their expertise would help. Coordinate their work and synthesize results."

    local model_args
    model_args=($(_cc_model_args))

    _cc_log "Starting B-thread with subagent delegation"
    _cc_hr

    claude "${model_args[@]}" \
        --append-system-prompt "$system_append" \
        "$@" \
        "$task"
}

# ==============================================================================
# G) L-THREAD: LONG DURATION
# ==============================================================================

# cc_lthread_remote - Start remote web session
# Usage: cc_lthread_remote "<task>"
cc_lthread_remote() {
    _cc_check_claude || return 1

    if [ $# -lt 1 ]; then
        printf '%s\n' "Usage: cc_lthread_remote \"<task>\"" >&2
        return 1
    fi

    _cc_log "Starting remote session..."
    claude --dangerously-skip-permissions "$@"
}

# cc_teleport - Teleport/attach to remote session
cc_teleport() {
    _cc_check_claude || return 1
    _cc_log "Teleporting to remote session..."
    claude --resume "$@"
}

# cc_lthread_loop - Local validation loop
# Usage: cc_lthread_loop "<validate_cmd>" "<prompt>"
cc_lthread_loop() {
    _cc_check_claude || return 1
    _cc_ensure_threads_dir || return 1

    if [ $# -lt 2 ]; then
        printf '%s\n' "Usage: cc_lthread_loop \"<validate_cmd>\" \"<prompt>\"" >&2
        return 1
    fi

    local validate_cmd="$1"
    local prompt="$2"
    shift 2

    local run_dir="${CC_THREADS_DIR}/$(_cc_timestamp)_lthread"
    mkdir -p "$run_dir" || return 1
    local log_file="${run_dir}/loop.log"

    local session_id
    session_id="lthread-$(_cc_uuid)"

    _cc_log "Starting L-thread validation loop" | tee "$log_file"
    _cc_log "Session ID: $session_id" | tee -a "$log_file"
    _cc_log "Validate command: $validate_cmd" | tee -a "$log_file"
    _cc_log "Run directory: $run_dir" | tee -a "$log_file"
    _cc_hr | tee -a "$log_file"

    local model_args print_args
    model_args=($(_cc_model_args))
    print_args=($(_cc_print_args))

    local iteration=0
    local max_iterations=20
    local validation_output
    local exit_code

    # Initial run
    _cc_log "Initial prompt execution..." | tee -a "$log_file"
    claude "${model_args[@]}" "${print_args[@]}" \
        --print "$prompt" \
        --dangerously-skip-permissions \
        "$@" \
        2>&1 | tee "${run_dir}/iter_0_output.txt" | tee -a "$log_file"

    while [ $iteration -lt $max_iterations ]; do
        iteration=$((iteration + 1))
        _cc_hr | tee -a "$log_file"
        _cc_log "Iteration $iteration: Running validation..." | tee -a "$log_file"

        # Run validation command
        validation_output="${run_dir}/iter_${iteration}_validation.txt"
        if bash -lc "$validate_cmd" > "$validation_output" 2>&1; then
            exit_code=0
        else
            exit_code=$?
        fi

        cat "$validation_output" | tee -a "$log_file"

        if [ $exit_code -eq 0 ]; then
            _cc_hr | tee -a "$log_file"
            _cc_log "VALIDATION PASSED on iteration $iteration" | tee -a "$log_file"
            _cc_log "Results saved to: $run_dir" | tee -a "$log_file"
            printf '%s\n' "PASSED"
            return 0
        fi

        _cc_log "Validation failed (exit: $exit_code), asking Claude to fix..." | tee -a "$log_file"

        # Get tail of validation output for fix prompt
        local failure_tail
        failure_tail=$(tail -50 "$validation_output")

        local fix_prompt
        fix_prompt="The validation command failed. Please analyze and fix the issues.

Validation command: $validate_cmd
Exit code: $exit_code

Failure output (last 50 lines):
\`\`\`
$failure_tail
\`\`\`

Please fix the issues and ensure the validation passes."

        # Continue session with fix request
        claude "${model_args[@]}" "${print_args[@]}" \
            --continue --print "$fix_prompt" \
            --dangerously-skip-permissions \
            2>&1 | tee "${run_dir}/iter_${iteration}_fix.txt" | tee -a "$log_file"
    done

    _cc_hr | tee -a "$log_file"
    _cc_log "ERROR: Max iterations ($max_iterations) reached without passing validation" | tee -a "$log_file"
    _cc_log "Results saved to: $run_dir" | tee -a "$log_file"
    return 1
}

# ==============================================================================
# H) Z-THREAD: ZERO-TOUCH-ISH (FAIL-CLOSED GATED)
# ==============================================================================

# cc_zthread - Fail-closed autopilot with gating
# Usage: cc_zthread "<validate_cmd>" "<prompt>"
cc_zthread() {
    _cc_check_claude || return 1

    if [ $# -lt 2 ]; then
        printf '%s\n' "Usage: cc_zthread \"<validate_cmd>\" \"<prompt>\"" >&2
        return 1
    fi

    local validate_cmd="$1"
    local prompt="$2"
    shift 2

    _cc_hr
    _cc_log "Z-THREAD: Zero-touch-ish execution (fail-closed)"
    _cc_log "Validation gate: $validate_cmd"
    _cc_hr
    printf '\n'

    # Run the validation loop
    if ! cc_lthread_loop "$validate_cmd" "$prompt" "$@"; then
        _cc_hr
        _cc_log "Z-THREAD FAILED: Validation did not pass"
        _cc_log "Review the logs and fix manually"
        return 1
    fi

    # Success - provide next steps
    _cc_hr
    _cc_log "Z-THREAD: Validation passed!"
    _cc_hr
    printf '\n'
    printf '%s\n' "=============================================="
    printf '%s\n' "  NEXT STEPS (Human Review Required)"
    printf '%s\n' "=============================================="
    printf '\n'
    printf '%s\n' "1. Review the changes:"
    printf '%s\n' "   git diff"
    printf '%s\n' "   git diff --staged"
    printf '\n'
    printf '%s\n' "2. Re-run validation to confirm:"
    printf '%s\n' "   $validate_cmd"
    printf '\n'
    printf '%s\n' "3. If satisfied, commit:"
    printf '%s\n' "   git add -A && git commit -m 'your message'"
    printf '\n'
    printf '%s\n' "4. Push when ready:"
    printf '%s\n' "   git push"
    printf '\n'
    printf '%s\n' "=============================================="
    _cc_log "Z-THREAD complete. Awaiting human signoff."
    return 0
}

# ==============================================================================
# SELF-TEST
# ==============================================================================

# cc_selftest - Verify setup and print configuration
cc_selftest() {
    local status=0

    printf '%s\n' "Claude Code Threads Toolkit - Self Test"
    _cc_hr

    # Check claude CLI
    printf '%s' "Claude CLI: "
    if command -v claude >/dev/null 2>&1; then
        printf '%s\n' "OK ($(command -v claude))"
    else
        printf '%s\n' "NOT FOUND"
        status=1
    fi

    # Print configuration
    printf '\n%s\n' "Configuration:"
    printf '%s\n' "  CC_MODEL:       $CC_MODEL"
    printf '%s\n' "  CC_OUTFMT:      $CC_OUTFMT"
    printf '%s\n' "  CC_MAX_TURNS:   $CC_MAX_TURNS"
    printf '%s\n' "  CC_THREADS_DIR: $CC_THREADS_DIR"
    printf '%s\n' "  CC_VALIDATE_CMD: ${CC_VALIDATE_CMD:-(not set)}"

    # Check directories
    printf '\n%s\n' "Directories:"
    printf '%s' "  Threads dir: "
    if [ -d "$CC_THREADS_DIR" ]; then
        if [ -w "$CC_THREADS_DIR" ]; then
            printf '%s\n' "OK (writable)"
        else
            printf '%s\n' "EXISTS but NOT WRITABLE"
            status=1
        fi
    else
        printf '%s' "Creating... "
        if mkdir -p "$CC_THREADS_DIR" 2>/dev/null; then
            printf '%s\n' "OK"
        else
            printf '%s\n' "FAILED"
            status=1
        fi
    fi

    # Check hooks
    printf '\n%s\n' "Hooks:"
    local hook_path="${HOME}/.claude/hooks/stop-validate.sh"
    printf '%s' "  Stop hook: "
    if [ -x "$hook_path" ]; then
        printf '%s\n' "OK (executable)"
    elif [ -f "$hook_path" ]; then
        printf '%s\n' "EXISTS but NOT EXECUTABLE"
    else
        printf '%s\n' "Not installed"
    fi

    # List available functions
    printf '\n%s\n' "Available functions:"
    printf '%s\n' "  Base:     cc, ccp"
    printf '%s\n' "  Approval: cc_plan, cc_step, cc_approve, cc_readonly, cc_yolo"
    printf '%s\n' "            ccp_plan, cc_confirm"
    printf '%s\n' "  Session:  cc_continue, cc_resume, cc_fork, ccp_continue"
    printf '%s\n' "  Parallel: cc_pthread"
    printf '%s\n' "  Chained:  cc_cthread"
    printf '%s\n' "  Fusion:   cc_fthread"
    printf '%s\n' "  Big:      cc_bthread"
    printf '%s\n' "  Long:     cc_lthread_remote, cc_teleport, cc_lthread_loop"
    printf '%s\n' "  Zero:     cc_zthread"
    printf '%s\n' "  Utility:  cc_selftest"

    _cc_hr
    if [ $status -eq 0 ]; then
        printf '%s\n' "Self-test: PASSED"
    else
        printf '%s\n' "Self-test: FAILED (see above)"
    fi

    return $status
}

# ==============================================================================
# COMPLETION SETUP (optional)
# ==============================================================================

# Basic completion for bash (add to bashrc if desired)
if [ -n "$BASH_VERSION" ]; then
    _cc_completions() {
        local cur="${COMP_WORDS[COMP_CWORD]}"
        local commands="cc ccp cc_plan cc_step cc_approve cc_readonly cc_yolo ccp_plan cc_confirm cc_continue cc_resume cc_fork ccp_continue cc_pthread cc_cthread cc_fthread cc_bthread cc_lthread_remote cc_teleport cc_lthread_loop cc_zthread cc_selftest"
        COMPREPLY=($(compgen -W "$commands" -- "$cur"))
    }
    complete -F _cc_completions cc
fi

# ==============================================================================
# EXPORT FUNCTIONS
# ==============================================================================

# Export all public functions for subshells
export -f cc ccp cc_plan cc_step cc_approve cc_readonly cc_yolo ccp_plan cc_confirm \
    cc_continue cc_resume cc_fork ccp_continue \
    cc_pthread cc_cthread cc_fthread cc_bthread \
    cc_lthread_remote cc_teleport cc_lthread_loop cc_zthread \
    cc_selftest 2>/dev/null || true

# Notify on source (optional, can be removed)
if [ -n "$CC_VERBOSE" ]; then
    _cc_log "Claude Code threads toolkit loaded. Run 'cc_selftest' to verify."
fi
