# Claude Code multi-profile shim, pyenv-style.
# Profile layout: ~/.claude-profiles/<name>/.claude with plaintext creds.
# The "default" profile unsets all vars and falls back to ~/.claude + Keychain.
# Sourced from zshrc before .zshrc.local so local overrides can further customise.

# WHY: switching envvars lets Claude pick up a different config/credentials dir
# without touching the default Keychain entry — same mechanic as pyenv's shims.
claude-use() {
  local profile="${1:-}"
  if [[ -z "$profile" ]]; then
    echo "usage: claude-use <profile> | default"
    return 1
  fi
  if [[ "$profile" == "default" ]]; then
    unset CLAUDE_CONFIG_DIR CLAUDE_CREDENTIALS_STORAGE CLAUDE_PROFILE
    echo "claude profile -> default (~/.claude, Keychain creds)"
  else
    local root="$HOME/.claude-profiles/$profile/.claude"
    mkdir -p "$root"
    export CLAUDE_PROFILE="$profile"
    export CLAUDE_CONFIG_DIR="$root"
    export CLAUDE_CREDENTIALS_STORAGE=plaintext
    echo "claude profile -> $profile ($root, plaintext creds)"
    [[ ! -f "$root/.credentials.json" ]] && echo "first run -> log in with: claude /login"
  fi
}

# WHY: prints active profile state so you can confirm which creds Claude will use.
claude-profile() {
  echo "profile : ${CLAUDE_PROFILE:-default}"
  echo "dir     : ${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
  echo "creds   : ${CLAUDE_CREDENTIALS_STORAGE:-keychain}"
}

# WHY: lists every profile directory so you can see what profiles exist at a glance.
claude-profiles() {
  echo "default -> $HOME/.claude"
  if [[ -d $HOME/.claude-profiles ]]; then
    for d in $HOME/.claude-profiles/*/.claude(N); do
      local name="${${d%/.claude}##*/}"
      printf "%-7s -> %s\n" "$name" "$d"
    done
  fi
}

# Short aliases for interactive use
alias cluse='claude-use'
alias clprof='claude-profile'
alias clps='claude-profiles'

# WHY: tab-completion suggests `default` plus every existing profile directory,
# so switching is a tab away and typos surface as "no match" instead of silent
# misconfiguration. Wired to both the full name and the `cluse` alias.
_claude-use() {
  local -a profiles
  profiles=(default)
  if [[ -d "$HOME/.claude-profiles" ]]; then
    local d
    for d in "$HOME/.claude-profiles"/*/.claude(N); do
      profiles+=("${${d%/.claude}##*/}")
    done
  fi
  _describe 'claude profile' profiles
}
compdef _claude-use claude-use cluse
