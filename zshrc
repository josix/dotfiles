# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_RPROMPT_ON_NEWLINE=true
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context kubecontext  virtualenv dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status battery root_indicator background_jobs time)
POWERLEVEL9K_VIRTUALENV_BACKGROUND='white'
POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND='red'
POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND='white'
POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND='red'
POWERLEVEL9K_DIR_HOME_BACKGROUND='green'
POWERLEVEL9K_DIR_HOME_FOREGROUND='black'
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND='green'
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND='black'
POWERLEVEL9K_VCS_CLEAN_FOREGROUND='blue'
POWERLEVEL9K_VCS_CLEAN_BACKGROUND='108'
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='yellow'
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='black'
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='white'
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='black'

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git extract zoxide zsh-autosuggestions ssh-agent docker docker-compose kubectl kubectx ) # item after \ need to be installed

# Homebrew prefix — set by `brew shellenv` in ~/.zprofile; avoid $(brew --prefix) subshells (~200ms each)
BREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"

# setting for zsh-completions — must be on FPATH before oh-my-zsh runs compinit
FPATH="$BREW_PREFIX/share/zsh-completions:$BREW_PREFIX/share/zsh/site-functions:$FPATH"

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='nvim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
#alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
alias less="bat"
alias l='eza --icons'
alias la='eza -lah --created --modified --icons --git --time-style iso'
alias ll='eza -lgh --created --modified --icons --git --time-style iso'
alias ls='eza --color=auto --icons'
alias ps="procs"
alias du="dust"
alias df="duf"
alias diff="delta"
alias glow="glow --pager"
alias f='fd . | rg'
alias tmuxn='tmux new -s $(basename $PWD)'
# kitty: copy terminfo to remote hosts so tmux/clear work over ssh
if [ -n "$KITTY_WINDOW_ID" ]; then
  export PATH="/Applications/kitty.app/Contents/MacOS:$PATH"
  alias ssh='kitten ssh'
fi
# alias for git
alias gii='git init && git commit --allow-empty -m "startup"'
alias gunch='git update-index --assume-unchanged'
alias gnunch='git update-index --no-assume-unchanged'
alias vim='nvim'

# pyenv — cache init script instead of running `pyenv init -` every startup (~300ms)
if command -v pyenv 1>/dev/null 2>&1; then
  if [[ ! -f "$ZSH_CACHE_DIR/pyenv-init.zsh" ]]; then
    pyenv init - > "$ZSH_CACHE_DIR/pyenv-init.zsh.$$" && mv "$ZSH_CACHE_DIR/pyenv-init.zsh.$$" "$ZSH_CACHE_DIR/pyenv-init.zsh"
  else
    { pyenv init - > "$ZSH_CACHE_DIR/pyenv-init.zsh.$$" && mv "$ZSH_CACHE_DIR/pyenv-init.zsh.$$" "$ZSH_CACHE_DIR/pyenv-init.zsh" } &|
  fi
  source "$ZSH_CACHE_DIR/pyenv-init.zsh"
fi

# Created by `pipx` on 2022-06-11 20:50:27
export PATH="$PATH:$HOME/.local/bin"
autoload -U bashcompinit
bashcompinit
# pipx completion — cached (~230ms per startup otherwise)
if [[ ! -f "$ZSH_CACHE_DIR/pipx-argcomplete.zsh" ]]; then
  register-python-argcomplete pipx > "$ZSH_CACHE_DIR/pipx-argcomplete.zsh"
fi
source "$ZSH_CACHE_DIR/pipx-argcomplete.zsh"

# enter gi for showing the content of gitignore file
function gi() { curl -sLw n https://www.gitignore.io/api/$@ ;}

# Disable homebrew auto update
export HOMEBREW_NO_AUTO_UPDATE=1

# Setting Docker image building platform for apple chip
# export DOCKER_DEFAULT_PLATFORM=linux/amd64

export PIPENV_VENV_IN_PROJECT=1
export PIP_REQUIRE_VIRTUALENV=true

export GOPATH=$HOME/go
export PATH="$GOPATH/bin:$PATH"

# kubectl completion is already handled (and cached) by the oh-my-zsh kubectl plugin.

# databricks completion — cached like helm/k9s below
if [[ $commands[databricks] ]]; then
  if [[ ! -f "$ZSH_CACHE_DIR/completions/_databricks" ]]; then
    databricks completion zsh > "$ZSH_CACHE_DIR/completions/_databricks.$$" && mv "$ZSH_CACHE_DIR/completions/_databricks.$$" "$ZSH_CACHE_DIR/completions/_databricks"
    source "$ZSH_CACHE_DIR/completions/_databricks"
  else
    source "$ZSH_CACHE_DIR/completions/_databricks"
    { databricks completion zsh > "$ZSH_CACHE_DIR/completions/_databricks.$$" && mv "$ZSH_CACHE_DIR/completions/_databricks.$$" "$ZSH_CACHE_DIR/completions/_databricks" } &|
  fi
fi

# nvm — lazy-loaded: sourcing nvm.sh eagerly costs ~660ms per shell
export NVM_DIR="$HOME/.nvm"
_load_nvm() {
  unset -f nvm node npm npx _load_nvm 2>/dev/null
  [ -s "$BREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$BREW_PREFIX/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "$BREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$BREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
}
for _cmd in nvm node npm npx; do
  eval "${_cmd}() { _load_nvm; ${_cmd} \"\$@\"; }"
done
unset _cmd
# Eagerly put the default node's bin on PATH (without sourcing nvm.sh) so
# non-interactive children (Claude Code, MCP servers, scripts) that resolve
# node/npx from PATH alone still find them.
_nvm_default="$(cat "$NVM_DIR/alias/default" 2>/dev/null)"
[[ -d "$NVM_DIR/versions/node/$_nvm_default" ]] || \
  _nvm_default="$(command ls "$NVM_DIR/versions/node" 2>/dev/null | sort -V | tail -1)"
[[ -n "$_nvm_default" ]] && path=("$NVM_DIR/versions/node/$_nvm_default/bin" $path)
unset _nvm_default
# If the completion file does not exist, generate it and then source it
# Otherwise, source it and regenerate in the background
if [[ ! -f "$ZSH_CACHE_DIR/completions/_helm" ]]; then
  helm completion zsh | tee "$ZSH_CACHE_DIR/completions/_helm" >/dev/null
  source "$ZSH_CACHE_DIR/completions/_helm"
else
  source "$ZSH_CACHE_DIR/completions/_helm"
  helm completion zsh | tee "$ZSH_CACHE_DIR/completions/_helm" >/dev/null &|
fi

if [[ ! -f "$ZSH_CACHE_DIR/completions/_k9s" ]]; then
  k9s completion zsh | tee "$ZSH_CACHE_DIR/completions/_k9s" >/dev/null
  source "$ZSH_CACHE_DIR/completions/_k9s"
else
  source "$ZSH_CACHE_DIR/completions/_k9s"
  k9s completion zsh | tee "$ZSH_CACHE_DIR/completions/_k9s" >/dev/null &|
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# fzf settingj
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Background-job picker (like an nvim buffer list): fzf over `jobs -l` with a
# live ps preview (state/CPU/elapsed), Enter = fg, Ctrl-K = kill,
# Ctrl-B = resume a Ctrl-Z-suspended job in the background (bg).
# Bound to Ctrl-X j; kitty's Cmd+Shift+F sends the same sequence.
fzf-job-picker() {
  local jl out key sel jobnum
  jl=$(builtin jobs -l)
  if [[ -z $jl ]]; then
    zle -M "no background jobs"
    return
  fi
  out=$(print -r -- "$jl" | fzf --height=~40% --reverse --prompt='job> ' \
        --header='enter: fg | ctrl-b: bg | ctrl-k: kill' --expect=ctrl-k,ctrl-b \
        --preview 'pid=$(grep -oE "[0-9]{2,}" <<< {} | head -1); ps -o pid,stat,%cpu,%mem,etime,command -p "$pid"' \
        --preview-window=down,3)
  key=${out%%$'\n'*}
  sel=${out#*$'\n'}
  if [[ -z $sel || $sel != \[* ]]; then
    zle reset-prompt
    return
  fi
  jobnum=${${sel#\[}%%\]*}
  if [[ $key == ctrl-k ]]; then
    kill "%$jobnum" 2>/dev/null
    zle reset-prompt
  elif [[ $key == ctrl-b ]]; then
    BUFFER="bg %$jobnum"
    zle accept-line
  else
    BUFFER="fg %$jobnum"
    zle accept-line
  fi
}
zle -N fzf-job-picker
bindkey '^Xj' fzf-job-picker

# TUIs (nvim, claude, ...) enable kitty's enhanced keyboard protocol; when
# suspended with Ctrl-Z it can stay active, leaving the shell receiving
# CSI-u encoded keys (Ctrl-A/Ctrl-E/Esc stop working). Pop the protocol
# state before every prompt so the shell always sees legacy key encoding.
if [[ -n $KITTY_WINDOW_ID ]]; then
  _kitty_kbd_reset() { printf '\e[<u' > /dev/tty }
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd _kitty_kbd_reset
fi

# export DOCKER_HOST="unix://$HOME/.local/share/containers/podman/machine/qemu/podman.sock"




function pushtag()
{
  if [ "$1" != "" ]
  then
    git tag preview-proj"$1" -f
    git push origin preview-proj"$1" -f
  else
    echo "should input tag name"
  fi
}
export PATH="$BREW_PREFIX/opt/openjdk@17/bin:$PATH"

alias aider='aider --env-file ~/aider/.env'

export PATH="$BREW_PREFIX/opt/postgresql@13/bin:$PATH"
export PATH="$BREW_PREFIX/opt/libpq/bin:$PATH"
export PATH="$HOME/.duckdb/cli/latest":$PATH
export PATH="$HOME/bin":$PATH
export PATH="$HOME/.bun/bin:$PATH"

# Claude Code multi-profile shim (see claude.zsh)
[[ -f ~/.claude.zsh ]] && source ~/.claude.zsh

# Load machine-specific / work-specific overrides if present
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

