# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH:$HOME/.local/bin:$HOME/Library/Python/3.7/bin

# Setting PATH for Python 3.5
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.5/bin:/opt/local/bin/:${PATH}"
export PATH
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Path to your oh-my-zsh installation.
export ZSH=/Users/wilson/.oh-my-zsh


# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel9k/powerlevel9k"

POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_RPROMPT_ON_NEWLINE=true
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context virtualenv dir vcs )
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

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=30

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM='~/.oh-my-zsh/custom/'

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git extract z \ zsh-iterm-touchbar zsh-autosuggestions) # item after \ need to be installed

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="mate ~/.zshrc"
alias ohmyzsh="mate ~/.oh-my-zsh"
alias ghost="ssh f103207425@ghost.cs.nccu.edu.tw"
alias wilson='cd ~/wilson'
alias grep='grep --color=auto'
alias ghost='ssh f103207425@ghost.cs.nccu.edu.tw'
alias arches='ssh -p 3322 sg35@140.119.55.171 '
alias fghost='sftp f103207425@ghost.cs.nccu.edu.tw'
#alias vim="vim -p"
alias wm5='python3 ~/selenium/school_redundant/wm5.py'
alias nccucs="ssh -p 3322 sg35@140.119.221.77"
alias wsm='ssh -p 22114 soslab@140.119.19.90'
alias tmux='/usr/local/Cellar/tmux/2.5/bin/tmux'
alias vim='/usr/local/Cellar/vim/8.1.0202/bin/vim'
alias vimdiff='/usr/local/Cellar/vim/8.1.0202//bin/vimdiff'
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
#alias g++='/usr/local/Cellar/gcc/8.2.0/bin/g++-8'
#alias c++='/usr/local/Cellar/gcc/8.2.0/bin/c++-8'
#alias gcc='/usr/local/Cellar/gcc/8.2.0/bin/gcc-8'
#alias cpp='/usr/local/Cellar/gcc/8.2.0/bin/cpp-8'
alias proNet-deepwalk='~/wilson/KKTeam/proNet-core/cli/deepwalk'
alias proNet-walklets='~/wilson/KKTeam/proNet-core/cli/walklets'
alias proNet-line='~/wilson/KKTeam/proNet-core/cli/line'
alias proNet-hpe='~/wilson/KKTeam/proNet-core/cli/hpe'
alias clip='ssh wilson@clip2.cs.nccu.edu.tw'
alias lat='ls -lhat'
alias cfda='ssh guest@140.109.21.238'

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
python() {
 local PYTHON="$(which python)"
 if [[ "$PYTHON" == /usr/* ]]; then
 echo "nope" >&2 | echo >/dev/null
 else
 "$PYTHON" "$@"
 fi
}

# Some installed tools setting
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


. /Users/wilson/torch/install/bin/torch-activate
export PATH="/usr/local/opt/llvm/bin:$PATH"
