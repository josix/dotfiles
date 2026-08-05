# dotfiles

## Quick Start

```bash
git clone <this-repo> ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

`bootstrap.sh` will install Homebrew (if missing), run `brew bundle`, install oh-my-zsh and Vundle, then symlink all dotfiles into `$HOME` (with timestamped backups of any pre-existing files).

After running bootstrap:

1. Copy `zshrc.local.example` to `~/.zshrc.local` and fill in your machine-specific and work-specific settings (trino aliases, `VAULT_ADDR`, hatch PATH appends, etc.).
2. Copy `gitconfig.local.example` to `~/.gitconfig.local` and fill in your name, email, and GPG signing key.
3. Open a new shell (`exec zsh`) and run `:PluginInstall` inside vim.
4. Launch `nvim` once — lazy.nvim bootstraps itself and installs the plugins pinned in `nvim/lazy-lock.json` (LazyVim-based config, symlinked to `~/.config/nvim`); language servers install via Mason on first use. Enable/disable language support with `:LazyExtras`.

To regenerate the `Brewfile` from your currently-installed packages:

```bash
brew bundle dump --describe --force --file=Brewfile
```

# for zshrc
1. install zsh
```bash
brew install zsh
```
2. change default shell
```bash
chsh -s $(which zsh)
```
or
```bash
chsh -s /bin/zsh
```
3. install oh-my-zsh
```bash
wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
sh install.sh
```

# for vimrc
1. install Vundle
```bash
cd ~
mkdir -p .vim/bundle
cd .vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git
```
2. install plunins
```vimscript
# open vim and enter...
:PluginInstall
```
3. install powerline fonts
```bash
# clone
git clone https://github.com/powerline/fonts.git
# install
cd fonts
./install.sh
# clean-up a bit
cd ..
rm -rf fonts
```
4. create a directory of editing history
```zsh
mkdir -p ~/.vim/undodir
```

> If using YCM, you need to go to the .vim/bundle/youcompleleme directory to run install.py with [lang-option](https://github.com/Valloric/YouCompleteMe#mac-os-x).

# for tmux
1. install tmux
```zsh
brew install tmux
```
2. reload tmux config
```zsh
 tmux source-file ~/.tmux.conf
```
