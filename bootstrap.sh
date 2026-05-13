#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$(uname)" != "Darwin" ]]; then
    echo "bootstrap.sh: macOS only. Aborting." >&2
    exit 1
fi

# 1. Homebrew
if ! command -v brew >/dev/null 2>&1; then
    echo "→ Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 2. Brewfile
if [[ -f "$DOTFILES_DIR/Brewfile" ]]; then
    echo "→ Running brew bundle"
    brew bundle install --file="$DOTFILES_DIR/Brewfile"
fi

# 3. oh-my-zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "→ Installing oh-my-zsh"
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# 4. Vundle
if [[ ! -d "$HOME/.vim/bundle/Vundle.vim" ]]; then
    echo "→ Installing Vundle"
    git clone https://github.com/VundleVim/Vundle.vim.git "$HOME/.vim/bundle/Vundle.vim"
fi

mkdir -p "$HOME/.vim/undodir"

# 5. Symlinks (with backup)
link() {
    local src="$1" dst="$2"
    if [[ -e "$dst" && ! -L "$dst" ]]; then
        local backup="${dst}.backup-$(date +%s)"
        echo "→ Backing up $dst → $backup"
        mv "$dst" "$backup"
    fi
    ln -sfn "$src" "$dst"
    echo "→ Linked $dst → $src"
}

link "$DOTFILES_DIR/zshrc"     "$HOME/.zshrc"
link "$DOTFILES_DIR/vimrc"     "$HOME/.vimrc"
link "$DOTFILES_DIR/gitconfig" "$HOME/.gitconfig"
link "$DOTFILES_DIR/tmux.conf" "$HOME/.tmux.conf"
link "$DOTFILES_DIR/p10k.zsh"  "$HOME/.p10k.zsh"

# 6. Next steps
cat <<EOF

Bootstrap complete.

Next steps:
  1. Create ~/.zshrc.local from zshrc.local.example and fill in your machine-
     specific and work-specific settings (trino aliases, VAULT_ADDR, hatch PATH, etc.)
  2. Create ~/.gitconfig.local from gitconfig.local.example with your name,
     email, and GPG signing key.
  3. Open a new shell (or run: exec zsh)
  4. Inside vim, run :PluginInstall to install vim plugins.

To regenerate the Brewfile from your actual installed packages later:
  brew bundle dump --describe --force --file="$DOTFILES_DIR/Brewfile"
EOF
