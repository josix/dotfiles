# Claude Code Threads Toolkit

A dotfiles-friendly shell toolkit implementing multiple execution modes ("threads") for Claude Code CLI.

## Thread Types

| Thread | Name | Description |
|--------|------|-------------|
| B0 | Base | One prompt → agent run → human review |
| P | Parallel | N concurrent runs (confidence testing or task splitting) |
| C | Chained | Multi-phase execution with checkpoints between phases |
| F | Fusion | N candidates generated, then synthesized into one answer |
| B | Big/Meta | Top-level orchestration with subagent delegation |
| L | Long | Long-running with validation loop |
| Z | Zero-touch | Fail-closed autopilot with gating and final human signoff |

## Installation

### 1. Source the main script

Add to your `~/.bashrc` or `~/.zshrc`:

```bash
# Claude Code Threads Toolkit
if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/claude/claude_threads.sh" ]; then
    source "${XDG_CONFIG_HOME:-$HOME/.config}/claude/claude_threads.sh"
fi
```

### 2. (Optional) Enable the stop-validation hook

Add to `~/.claude/settings.json`:

```json
{
  "hooks": {
    "stop": [
      {
        "type": "command",
        "command": "$HOME/.claude/hooks/stop-validate.sh"
      }
    ]
  }
}
```

### 3. Verify installation

```bash
source ~/.bashrc  # or restart your shell
cc_selftest
```

## Configuration

Override defaults via environment variables in your shell rc:

```bash
# Model selection (default: opus)
export CC_MODEL="sonnet"

# Output format for print mode (default: text)
# Options: text, json, stream-json
export CC_OUTFMT="text"

# Directory for thread outputs (default: ~/.local/state/cc-threads)
export CC_THREADS_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/cc-threads"

# Max turns limit, 0 = unlimited (default: 0)
export CC_MAX_TURNS=50

# Default validation command for hooks
export CC_VALIDATE_CMD="npm test"

# Enable verbose loading message
export CC_VERBOSE=1
```

## Function Reference

### Base Wrappers (B0 Thread)

#### `cc` - Interactive REPL

```bash
# Start interactive session
cc

# With initial prompt
cc "Help me refactor this function"

# With extra flags
cc --allowedTools "Read,Write,Edit" "Fix the bug in main.py"
```

#### `ccp` - Print Mode (Script-Friendly)

```bash
# Single prompt, get response to stdout
ccp "Explain this error: $error_msg"

# Pipe output
ccp "Generate a UUID" > uuid.txt

# Use in scripts
result=$(ccp "What is 2+2?")
```

### Approval Mode Wrappers

Control how Claude asks for permission before taking actions.

#### `cc_plan` - Plan Mode (Approve Before Execution)

Claude presents a complete plan first, then executes only after approval.

```bash
# Claude will show the plan and ask for approval
cc_plan "Refactor the authentication module"

# Good for: complex changes where you want to review the approach first
```

#### `cc_step` - Step-by-Step Mode (Default Behavior)

Explicit name for Claude's default permission prompting.

```bash
# Same as cc, but makes intent clear
cc_step "Fix the bug in payment processing"
```

#### `cc_approve` - Restricted Tool Approval

Run with specific allowed tools only.

```bash
# Only allow read operations and grep
cc_approve "Analyze this codebase" "Read,Grep,Glob"

# Allow edits but not bash
cc_approve "Update the config files" "Read,Edit,Write"
```

#### `cc_readonly` - Read-Only Mode

Only allows non-modifying operations (safe for exploration).

```bash
# Safe exploration - cannot modify anything
cc_readonly "Explain how the auth system works"

# Good for: code review, learning, analysis
```

#### `cc_yolo` - Skip All Permissions (Use with Caution!)

Bypasses all permission prompts. Only use for trusted, well-understood tasks.

```bash
# WARNING: No permission prompts!
cc_yolo "Run the standard migration script"
```

#### `ccp_plan` - Print Mode with Plan Preview

Shows the plan first, asks for confirmation, then executes.

```bash
# Review plan before execution
ccp_plan "Add input validation to all API endpoints"

# Output: Shows plan, asks y/N, then executes if approved
```

#### `cc_confirm` - Interactive Step-by-Step Confirmation

Most controlled mode: approves each step individually with revert option.

```bash
# Execute with confirmation after each step
cc_confirm "Migrate the database schema"

# At each step you can:
# - [y] Continue to next step
# - [r] Revert the last action
# - [d] Mark as done and stop
# - [n] Stop execution
```

**Approval Mode Comparison:**

| Function | Permission Level | Use Case |
|----------|-----------------|----------|
| `cc_yolo` | None (skip all) | Trusted automation |
| `cc` / `cc_step` | Per-action | Normal interactive use |
| `cc_plan` | Plan approval | Complex changes |
| `cc_approve` | Tool-restricted | Limited scope tasks |
| `cc_readonly` | Read-only | Safe exploration |
| `cc_confirm` | Per-step + revert | Critical changes |

### Session Helpers

#### `cc_continue` - Continue Most Recent Session

```bash
# Continue where you left off (in current directory)
cc_continue

# With new prompt
cc_continue "Now let's add tests"
```

#### `cc_resume` - Resume by Session ID

```bash
# Interactive picker
cc_resume

# Specific session
cc_resume abc123-def456
```

#### `cc_fork` - Fork Session

```bash
# Fork and continue (creates new branch of conversation)
cc_fork
```

#### `ccp_continue` - Continue in Print Mode

```bash
# Continue with a prompt, get output
ccp_continue "Summarize what we did"
```

### P-Thread: Parallel Execution

Run N identical prompts concurrently for confidence testing or different approaches.

```bash
# Run 3 parallel instances
cc_pthread 3 "Review this code for security issues"

# Run 5 instances with extra flags
cc_pthread 5 "Suggest optimizations for main.py" --allowedTools "Read,Grep"
```

**Output structure:**
```
~/.local/state/cc-threads/20240115_143022_pthread/
├── out_1.txt
├── out_2.txt
├── out_3.txt
├── err_1.txt
├── err_2.txt
└── err_3.txt
```

**Use cases:**
- Confidence testing: run same prompt multiple times, compare answers
- Brainstorming: get multiple independent approaches
- Parallel code review with different foci

### C-Thread: Chained/Phased Execution

Execute phases sequentially with human checkpoints between each.

```bash
# Create a phases file
cat > phases.txt << 'EOF'
# Phase 1: Analysis
Analyze the current architecture and identify pain points

# Phase 2: Design
Design a refactoring plan based on the analysis

# Phase 3: Implementation
Implement the first refactoring step

# Phase 4: Testing
Write tests for the changes
EOF

# Run chained execution
cc_cthread phases.txt
```

**Behavior:**
- Each phase runs with `--continue` (maintains context)
- After each phase: "Press Enter to continue or Ctrl+C to stop"
- All outputs logged to timestamped directory

### F-Thread: Fusion

Generate N candidates then synthesize the best answer.

```bash
# Generate 3 candidates and fuse
cc_fthread 3 "Implement a rate limiter in Python"

# More candidates for complex problems
cc_fthread 5 "Design a caching strategy for our API"
```

**Output structure:**
```
~/.local/state/cc-threads/20240115_143522_fthread/
├── cand_1.txt
├── cand_2.txt
├── cand_3.txt
├── fusion_input.txt
└── fused.txt        # Final synthesized result
```

**The fusion prompt automatically:**
- Identifies best elements from each candidate
- Resolves conflicts
- Adds confidence level and risk assessment

### B-Thread: Big/Meta with Subagents

Run an interactive session with built-in subagent delegation.

```bash
# Complex task with subagent support
cc_bthread "Investigate the memory leak in production and fix it"

# Code review task
cc_bthread "Review PR #123 for security and performance issues"
```

**Built-in subagents:**
- `code-reviewer`: Security and correctness analysis
- `debugger`: Systematic debugging with root cause analysis
- `researcher`: Documentation and example finding

### L-Thread: Long Duration

#### `cc_lthread_remote` - Remote Web Session

```bash
# Start a remote session for long-running work
cc_lthread_remote "Refactor the entire auth module"
```

#### `cc_teleport` - Attach to Remote Session

```bash
# Reconnect to a remote session
cc_teleport
```

#### `cc_lthread_loop` - Validation Loop

Runs Claude, validates, and loops until validation passes.

```bash
# Loop until tests pass
cc_lthread_loop "npm test" "Fix all failing tests in the auth module"

# Loop until build succeeds
cc_lthread_loop "cargo build --release" "Fix the compilation errors"

# Loop until linting passes
cc_lthread_loop "eslint src/ --max-warnings 0" "Fix all linting errors"

# Custom validation script
cc_lthread_loop "./scripts/validate.sh" "Implement the new feature"
```

**Behavior:**
1. Runs initial prompt
2. Runs validation command
3. If fails: sends failure output to Claude, asks to fix
4. Repeats until validation passes (max 20 iterations)

**Output structure:**
```
~/.local/state/cc-threads/20240115_144022_lthread/
├── loop.log
├── iter_0_output.txt
├── iter_1_validation.txt
├── iter_1_fix.txt
├── iter_2_validation.txt
└── iter_2_fix.txt
```

### Z-Thread: Zero-Touch-ish (Fail-Closed)

Automated execution with strict validation gating and human signoff guidance.

```bash
# Implement with test validation
cc_zthread "pytest" "Add input validation to the API endpoints"

# Implement with build validation
cc_zthread "make build && make test" "Migrate from callbacks to async/await"

# Implement with custom validation
cc_zthread "./ci/validate.sh" "Implement the payment integration"
```

**Behavior:**
1. Runs `cc_lthread_loop` until validation passes
2. On success, prints next-step instructions:
   - Review changes with `git diff`
   - Re-run validation
   - Commit when satisfied
3. Does NOT auto-commit or push

## Stop Hook Validation

The stop-validate hook blocks Claude from completing until validation passes.

### Setup

1. Ensure hook is executable:
```bash
chmod +x ~/.claude/hooks/stop-validate.sh
```

2. Add to `~/.claude/settings.json`:
```json
{
  "hooks": {
    "stop": [
      {
        "type": "command",
        "command": "$HOME/.claude/hooks/stop-validate.sh"
      }
    ]
  }
}
```

### Validation Resolution

The hook finds a validation command in this order:

1. **Project-specific**: `$CLAUDE_PROJECT_DIR/.claude/hooks/validate.sh`
2. **Environment variable**: `$CC_VALIDATE_CMD`
3. **No-op**: Allows stop if neither is configured

### Project-Specific Validator

Create `.claude/hooks/validate.sh` in your project:

```bash
#!/usr/bin/env bash
# .claude/hooks/validate.sh
set -euo pipefail

echo "Running project validation..."

# Run tests
npm test

# Check types
npm run typecheck

# Lint
npm run lint

echo "All validations passed!"
```

Make executable:
```bash
chmod +x .claude/hooks/validate.sh
```

## Examples

### Example 1: Confidence Testing with P-Thread

```bash
# Ask 5 parallel instances to review code
cc_pthread 5 "Review src/auth.py for security vulnerabilities. List issues by severity."

# Compare outputs
cd ~/.local/state/cc-threads/
ls -lt | head -2  # Find latest pthread dir
diff out_1.txt out_2.txt  # Compare responses
```

### Example 2: Phased Refactoring with C-Thread

```bash
cat > refactor_phases.txt << 'EOF'
Analyze the current database.py module: identify coupling issues, missing abstractions, and test coverage gaps

Based on the analysis, create a refactoring plan with 3-5 concrete steps. Prioritize by impact and risk.

Implement step 1 of the refactoring plan. Make minimal changes to preserve behavior.

Write unit tests for the changes made in step 1. Ensure edge cases are covered.

Review the implementation: verify tests pass, check for regressions, document any API changes.
EOF

cc_cthread refactor_phases.txt
```

### Example 3: Fusion for Algorithm Design

```bash
# Get 4 different approaches, then fuse the best
cc_fthread 4 "Design a rate limiting algorithm for our API that:
- Handles 10k requests/second
- Supports per-user and global limits
- Is horizontally scalable
- Has O(1) check time"
```

### Example 4: Big Thread for Investigation

```bash
cc_bthread "Our production API is returning 500 errors intermittently.
Investigate the issue:
1. Check recent deployments
2. Analyze error logs
3. Review related code changes
4. Identify root cause
5. Propose and implement a fix"
```

### Example 5: Validation Loop with pytest

```bash
cc_lthread_loop "pytest -x" "Fix the failing test in test_auth.py - the token validation is rejecting valid tokens"
```

### Example 6: Zero-Touch Feature Implementation

```bash
# Implement feature with CI validation
cc_zthread "npm run ci" "Add rate limiting middleware to the Express app:
- Use sliding window algorithm
- 100 requests per minute per IP
- Return 429 with Retry-After header
- Add tests"

# When complete, follow the printed instructions:
# git diff
# npm run ci
# git add -A && git commit -m 'Add rate limiting middleware'
```

### Example 7: Print Mode in Scripts

```bash
#!/usr/bin/env bash
# generate_docs.sh - Generate documentation for all Python files

for file in src/*.py; do
    echo "Documenting $file..."
    doc=$(ccp "Generate docstrings for all functions in this file. Output only the updated file content." < "$file")
    echo "$doc" > "${file%.py}_documented.py"
done
```

## Troubleshooting

### cc_selftest fails

```bash
# Check if claude is installed
which claude

# Check if directories exist and are writable
ls -la ~/.local/state/cc-threads/
ls -la ~/.claude/hooks/
```

### Validation hook not triggering

1. Check settings.json syntax
2. Verify hook is executable: `ls -la ~/.claude/hooks/stop-validate.sh`
3. Check hook output: `echo '{}' | ~/.claude/hooks/stop-validate.sh`

### Parallel runs failing

Ensure `--dangerously-skip-permissions` is acceptable for your use case, or add appropriate flags.

## Files

- `~/.config/claude/claude_threads.sh` - Main toolkit script
- `~/.claude/hooks/stop-validate.sh` - Stop validation hook
- `~/.config/claude/README_threads.md` - This documentation
- `~/.local/state/cc-threads/` - Output directory for thread runs

## License

MIT - Use freely in your dotfiles.
