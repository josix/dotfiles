# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
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
plugins=(git extract zoxide z vault zsh-autosuggestions ssh-agent docker docker-compose kubectl kubectx ) # item after \ need to be installed

  source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

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
alias l='exa --icons'
alias la='exa -lah --created --modified --icons --git --time-style iso'
alias ll='exa -lgh --created --modified --icons --git --time-style iso'
alias ls='exa --color=auto --icons'
alias ps="procs"
alias du="dust"
alias df="duf"
alias diff="delta"
alias tmuxn='tmux new -s $(basename $PWD)'
# alias for git
alias gii='git init && git commit --allow-empty -m "startup"'
alias gunch='git update-index --assume-unchanged'
alias gnunch='git update-index --no-assume-unchanged'

# setting for zsh-completions
FPATH=$(brew --prefix)/share/zsh-completions:$(brew --prefix)/share/zsh/site-functions:$FPATH
autoload -Uz compinit
compinit

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi


# Created by `pipx` on 2022-06-11 20:50:27
export PATH="$PATH:/Users/wilson/.local/bin"
autoload -U bashcompinit
bashcompinit
eval "$(register-python-argcomplete pipx)"

# setting for nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# enter gi for showing the content of gitignore file
function gi() { curl -sLw n https://www.gitignore.io/api/$@ ;}

# Making zsh command highlighting
source /Users/wilson/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Disable homebrew auto update
export HOMEBREW_NO_AUTO_UPDATE=1

# Setting Docker image building platform for apple chip
# export DOCKER_DEFAULT_PLATFORM=linux/amd64

export PIPENV_VENV_IN_PROJECT=1
export PIP_REQUIRE_VIRTUALENV=true

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
export GOPATH=$HOME/go
export PATH="$(go env GOPATH)/bin:$PATH"
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
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

# airflow breeze
source ~/wilson/airflow/airflow/dev/breeze/autocomplete/breeze-complete-zsh.sh

# export DOCKER_HOST="unix:///Users/wilson.wang/.local/share/containers/podman/machine/qemu/podman.sock"



export VAULT_ADDR=https://vault.appier.us/
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
# autossh -f -M 0 -o "ServerAliveInterval 10" -o "ServerAliveCountMax 3" -NL 27018:aixon-stg-percona-1.arepa.appier.info:27017 wilson-wang@bastion-arepa-ase1.arepa.appier.info -i ~/.ssh/aixon/aixon
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
alias gcp-trino='trino-cli  --server https://trino-abs-aixon-stg.gcp-asne1.edp.appier.info --catalog hive --user aixon-stg/pipeline --krb5-config-path ~/edp-trino/krb5.conf --krb5-principal aixon-stg/pipeline@APPIER.INFO --krb5-keytab-path ~/edp-trino/aws-pipeline.keytab --krb5-remote-service-name trino --krb5-service-principal-pattern trino@trino-abs-aixon-stg.gcp-asne1.edp.appier.info'
alias gcp-prd-trino='trino-cli  --server https://trino-abs-aixon-pipeline.gcp-asne1.edp.arepa.appier.info --catalog hive --user aixon-prd/pipeline --krb5-config-path ~/edp-trino/krb5.conf --krb5-principal aixon-prd/pipeline@APPIER.INFO --krb5-keytab-path ~/edp-trino/pipeline-prd.keytab --krb5-remote-service-name trino --krb5-service-principal-pattern trino@trino-abs-aixon-pipeline.gcp-asne1.edp.arepa.appier.info'
alias aws-trino='trino-cli  --server https://trino-abs-general.aws-apse1.edp.appier.info/ --catalog hive --user aixon-stg/pipeline --krb5-config-path ~/edp-trino/krb5.conf --krb5-principal aixon-stg/pipeline@APPIER.INFO --krb5-keytab-path ~/edp-trino/aws-pipeline.keytab --krb5-remote-service-name trino --krb5-service-principal-pattern trino@trino-abs-general.aws-apse1.edp.appier.info'

alias aider='aider --env-file ~/aider/.env'
# START: Added by Updated Airflow Breeze autocomplete setup
source /Users/wilson.wang/wilson/airflow/airflow/dev/breeze/autocomplete/breeze-complete-zsh.sh
# END: Added by Updated Airflow Breeze autocomplete setup

# Created by `userpath` on 2024-08-13 18:25:18
export PATH="$PATH:/Users/wilson.wang/Library/Application Support/hatch/pythons/3.8/python/bin"

# Created by `userpath` on 2024-08-13 18:25:27
export PATH="$PATH:/Users/wilson.wang/Library/Application Support/hatch/pythons/3.9/python/bin"

# Created by `userpath` on 2024-08-13 18:25:38
export PATH="$PATH:/Users/wilson.wang/Library/Application Support/hatch/pythons/3.10/python/bin"

# Created by `userpath` on 2024-08-13 18:25:48
export PATH="$PATH:/Users/wilson.wang/Library/Application Support/hatch/pythons/3.11/python/bin"

# Created by `userpath` on 2024-08-13 18:26:02
export PATH="$PATH:/Users/wilson.wang/Library/Application Support/hatch/pythons/3.12/python/bin"

# Created by `userpath` on 2024-08-13 18:26:13
export PATH="$PATH:/Users/wilson.wang/Library/Application Support/hatch/pythons/pypy2.7/pypy2.7-v7.3.15-macos_arm64/bin"

# Created by `userpath` on 2024-08-13 18:26:25
export PATH="$PATH:/Users/wilson.wang/Library/Application Support/hatch/pythons/pypy3.9/pypy3.9-v7.3.15-macos_arm64/bin"

# Created by `userpath` on 2024-08-13 18:26:37
export PATH="$PATH:/Users/wilson.wang/Library/Application Support/hatch/pythons/pypy3.10/pypy3.10-v7.3.15-macos_arm64/bin"
