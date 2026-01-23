#!/usr/bin/env bash
# stop-validate.sh - Claude Code Stop Hook for validation gating
#
# This hook runs when Claude attempts to stop/complete a session.
# It can block the stop if validation fails, prompting Claude to fix issues.
#
# Installation:
#   1. Place this file at ~/.claude/hooks/stop-validate.sh
#   2. Make executable: chmod +x ~/.claude/hooks/stop-validate.sh
#   3. Add to ~/.claude/settings.json (see README_threads.md)
#
# Validation command resolution order:
#   1. Project-specific: $CLAUDE_PROJECT_DIR/.claude/hooks/validate.sh
#   2. Environment variable: CC_VALIDATE_CMD
#   3. No-op (allow stop)
#
# Exit codes:
#   0 - Allow stop (validation passed or no validation configured)
#   2 - Block stop (validation failed; Claude should fix and retry)

set -euo pipefail

# ==============================================================================
# CONFIGURATION
# ==============================================================================

readonly LOG_PREFIX="[stop-validate]"

# Maximum validation output to include in error message
readonly MAX_OUTPUT_LINES=30

# ==============================================================================
# UTILITIES
# ==============================================================================

log_info() {
    printf '%s %s\n' "$LOG_PREFIX" "$*" >&2
}

log_error() {
    printf '%s ERROR: %s\n' "$LOG_PREFIX" "$*" >&2
}

# ==============================================================================
# MAIN LOGIC
# ==============================================================================

main() {
    # Read hook payload from stdin
    local payload
    payload=$(cat)

    # Check for infinite loop prevention
    # If the payload indicates this is already a validation-triggered stop,
    # allow it to prevent infinite loops
    if printf '%s' "$payload" | grep -q '"stop_hook_active"[[:space:]]*:[[:space:]]*true'; then
        log_info "Stop hook already active, allowing stop to prevent loop"
        exit 0
    fi

    # Determine validation command
    local validate_cmd=""
    local validate_source=""

    # Priority 1: Project-specific validator
    if [ -n "${CLAUDE_PROJECT_DIR:-}" ]; then
        local project_validator="${CLAUDE_PROJECT_DIR}/.claude/hooks/validate.sh"
        if [ -x "$project_validator" ]; then
            validate_cmd="$project_validator"
            validate_source="project"
        fi
    fi

    # Priority 2: Environment variable
    if [ -z "$validate_cmd" ] && [ -n "${CC_VALIDATE_CMD:-}" ]; then
        validate_cmd="$CC_VALIDATE_CMD"
        validate_source="env"
    fi

    # Priority 3: No validation configured - allow stop
    if [ -z "$validate_cmd" ]; then
        log_info "No validation configured, allowing stop"
        exit 0
    fi

    log_info "Running validation ($validate_source): $validate_cmd"

    # Create temp file for validation output
    local output_file
    output_file=$(mktemp)
    trap 'rm -f "$output_file"' EXIT

    # Run validation
    local exit_code=0
    if bash -lc "$validate_cmd" > "$output_file" 2>&1; then
        exit_code=0
    else
        exit_code=$?
    fi

    if [ $exit_code -eq 0 ]; then
        log_info "Validation PASSED"
        exit 0
    fi

    # Validation failed - block stop
    log_error "Validation FAILED (exit code: $exit_code)"

    # Print actionable error message
    printf '\n%s\n' "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
    printf '%s\n' "STOP BLOCKED: Validation failed" >&2
    printf '%s\n' "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
    printf '\n%s\n' "Validation command: $validate_cmd" >&2
    printf '%s\n' "Exit code: $exit_code" >&2
    printf '\n%s\n\n' "Output (last $MAX_OUTPUT_LINES lines):" >&2

    tail -n "$MAX_OUTPUT_LINES" "$output_file" >&2

    printf '\n%s\n' "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
    printf '%s\n' "Please fix the issues above before completing." >&2
    printf '%s\n' "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2

    # Exit code 2 blocks the stop
    exit 2
}

main "$@"
