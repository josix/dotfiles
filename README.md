# dotfiles
# for zshrc
1. install zsh
```bash
brew install zsh
```
2. change default shell
```bash
chsh -s /usr/local/bin/zsh
```
or
```bash
chsh -s /bin/zsh
```
3. install oh-my-zsh
```bash
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
```

# for vimrc
1. install Vundle
```bash
cd ~
mkdir -p .vim/bundle
cd .vim/bundle
git clone git clone https://github.com/VundleVim/Vundle.vim.git
```
2. install plunins
```vimscript
# open vim and enter...
:PlugInstall 
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
4. create Vim editing history directory
```zsh
mkdir -p /.vim/undodir
```

# for tmux
1. install tmux
```zsh
brew install tmux
```
2. reload tmux config
```zsh
 tmux source-file ~/.tmux.conf
```
