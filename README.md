# dotfiles

## Quick Start

```bash
git clone <this-repo> ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

`bootstrap.sh` will install Homebrew (if missing), run `brew bundle`, install oh-my-zsh and Vundle, then symlink `zshrc`, `vimrc`, `gitconfig`, `tmux.conf`, `p10k.zsh`, and `claude.zsh` into `$HOME`, plus `nvim/` into `~/.config/nvim`, and `kitty.conf` and `kitty/dark-theme.auto.conf` into `~/.config/kitty/` (with timestamped backups of any pre-existing files).

After running bootstrap:

1. Copy `zshrc.local.example` to `~/.zshrc.local` and fill in your machine-specific and work-specific settings (trino aliases, `VAULT_ADDR`, hatch PATH appends, etc.).
2. Copy `gitconfig.local.example` to `~/.gitconfig.local` and fill in your name, email, and GPG signing key.
3. Install kitty and a Nerd Font — neither is in the `Brewfile`, so `brew bundle` won't install them. For example: `brew install --cask kitty` and `brew install --cask font-fira-code-nerd-font` (verify current cask names with `brew search`). `kitty.conf` is set up for Fira Code with a Nerd Font symbol map.
4. Open a new shell (`exec zsh`).
5. Launch `nvim` once — lazy.nvim bootstraps and installs the plugins pinned in `nvim/lazy-lock.json`; Mason installs LSPs on first use.

To regenerate the `Brewfile` from your currently-installed packages:

```bash
brew bundle dump --describe --force --file=Brewfile
```

## What's in here

| File | Symlink target | Notes |
|---|---|---|
| `zshrc` | `~/.zshrc` | |
| `vimrc` | `~/.vimrc` | legacy, see `# legacy` |
| `gitconfig` | `~/.gitconfig` | |
| `tmux.conf` | `~/.tmux.conf` | |
| `p10k.zsh` | `~/.p10k.zsh` | |
| `claude.zsh` | `~/.claude.zsh` | multi-profile Claude Code shim |
| `nvim/` | `~/.config/nvim` | |
| `kitty.conf` | `~/.config/kitty/kitty.conf` | |
| `kitty/dark-theme.auto.conf` | `~/.config/kitty/dark-theme.auto.conf` | dark-mode palette (brightened Zenburn red) |
| `MyProfile.json` | not linked | reference only, not linked by bootstrap |
| `MyIterm2Color.itermcolors` | not linked | reference only, not linked by bootstrap |
| `Raycast.rayconfig` | not linked | reference only, not linked by bootstrap |
| `iTerm2-Color-Schemes` | not linked | submodule, reference only, not linked by bootstrap |

# for zshrc
Bootstrap already runs the oh-my-zsh install, so these steps are for reference or for setting up a machine without running `bootstrap.sh`.

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

`claude.zsh` is a multi-profile Claude Code shim, sourced by `zshrc`.

# for nvim
LazyVim starter config, lives in `nvim/`, symlinked to `~/.config/nvim` by `bootstrap.sh`. `brew "neovim"` is in the `Brewfile`, so bootstrap installs the binary.

- First launch bootstraps lazy.nvim; plugin versions are pinned in `nvim/lazy-lock.json`; Mason installs LSPs on demand.
- Language support is toggled via `:LazyExtras`; enabled extras live in `nvim/lazyvim.json`.
- Colorscheme: zenburn (`nvim/lua/plugins/colorscheme.lua`).
- Minimap: `<leader>mm` toggles, `<leader>mf` focuses (`nvim/lua/plugins/minimap.lua`).
- `jj` exits insert mode (`nvim/lua/config/keymaps.lua`).
- Focus Mode (centered cursor + scope dim) is on by default; `<leader>uo` toggles it. Tab/Shift-Tab cycle completion suggestions (`nvim/lua/plugins/blink.lua`).
- Whitespace rendering and an nvm node PATH shim for Mason (`nvim/lua/config/options.lua`).
- `alias vim='nvim'` (`zshrc`) — typing `vim` in an interactive shell gets Neovim.

Full walkthrough: [nvim/GUIDE.md](nvim/GUIDE.md).

# for kitty
Install: `brew install --cask kitty` plus a Nerd Font (see Quick Start step 3).

Config: `kitty.conf` at the repo root, symlinked to `~/.config/kitty/kitty.conf` by `bootstrap.sh`.

On first launch, kitty warns because `kitty.conf` includes `current-theme.conf`, which is not tracked in this repo. Generate it with `kitten themes` or comment out the include — don't edit `kitty.conf` itself.

Orientation:

- `ctrl+a` is the tmux-style prefix for splits, tabs, and layouts.
- Plain `cmd` shortcuts cover the iTerm2-style habits (splits, resize, fullscreen, clipboard).
- `ctrl+a>v` opens the Dev tab; `ctrl+a>shift+l` opens the Logs tab.
- Claude Code panes: `cmd+shift+c` or `ctrl+a>a`.
- `cmd+f` sends `fg` to resume a suspended job; `cmd+b` sends `bg` to resume it in the background after Ctrl-Z; `cmd+shift+f` opens the zsh fzf job picker (also bound to Ctrl-X j) — Enter=fg, Ctrl-B=bg, Ctrl-K=kill.
- Inside kitty, `ssh` is aliased to `kitten ssh`.

Full walkthrough: [kitty/GUIDE.md](kitty/GUIDE.md).

# for tmux
1. install tmux
```zsh
brew install tmux
```
2. reload tmux config
```zsh
 tmux source-file ~/.tmux.conf
```

# legacy
Superseded by the nvim config above, but `vimrc` is still tracked and symlinked (`bootstrap.sh`), Vundle is still installed by bootstrap, and `brew "vim"` remains in the `Brewfile`. Because of the `alias vim='nvim'` in `zshrc`, reach legacy vim with `\vim` or `command vim`.

## vim (Vundle)
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

Known quirks (not fixed here):
- `git` still opens real vim — `gitconfig`'s `editor = vim` calls the binary directly, so the shell alias never applies.
- `bootstrap.sh` still advertises `:PluginInstall` as a next step; it only applies to this legacy config.

## iTerm2 assets
`MyIterm2Color.itermcolors`, `MyProfile.json`, and the `iTerm2-Color-Schemes` submodule are tracked but referenced nowhere in `bootstrap.sh`. Kept for reference after the move to kitty; the submodule is not initialized by bootstrap.
