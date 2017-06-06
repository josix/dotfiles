"========================================Setting Plugin======================================================
filetype off                 " required!
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle
" required!
Plugin 'VundleVim/Vundle.vim'
" My Bundles here:
"
" original repos on github
Plugin 'itchyny/lightline.vim' "statusline
Plugin 'bling/vim-bufferline' "vim bufferline bar
Plugin 'lokaltog/vim-powerline' "statusline
Plugin 'bling/vim-airline' "statusline
Plugin 'vim-airline/vim-airline-themes'
Plugin 'ervandew/supertab' "allows you to use <Tab> for all your insert
Plugin 'tpope/vim-fugitive' "status git branch
Plugin 'ntpeters/vim-better-whitespace' "check the tailing space
Plugin 'easymotion/vim-easymotion' "vim motion on speed
Plugin 'scrooloose/nerdtree' "A tree explorer plugin for vim
Plugin 'AutoComplPop'
Plugin 'moskytw/luthadel.vim' " color scheme
Plugin 'altercation/vim-colors-solarized' " color scheme
Plugin 'vimwiki/vimwiki'
Plugin 'majutsushi/tagbar'
Plugin 'chrisbra/csv.vim'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"
"===========================================Setting for Plugin=====================================================
"toggle black/light for solarized
call togglebg#map("<f5>")

"setting for airline
set nocompatible   " Disable vi-compatibility
set laststatus=2   " Always show the statusline
set encoding=utf-8 " Necessary to show Unicode glyphs
set t_Co=256 " Explicitly tell Vim that the terminal supports 256 colors
let g:airline_powerline_fonts = 1
let g:airline_theme='base16'

"setting for tagbar
set tags+=tags;/

"===========================================setting status=====================================================
" setting to open the file syntax, automaticlly dective file type like python, c...so as to show up the syntax
syntax on
let g:solarized_termcolors=256
set background=dark
colorscheme solarized


"setting the line number and relative line number(and color)
set nu
set relativenumber
"hi LineNr ctermfg=228
"hi CursorLineNr ctermfg=221
"setting the tab width"
set tabstop=4
set shiftwidth=4 "for entering >> and <<"
"set indentation level symbol
set listchars=tab:\¦\ 
set list
"setting the cursor line "
set cursorline
"hi CursorLine cterm=NONE ctermbg=238 "ctermfg=white guibg=darkred guifg=white "cterm for color terminal term for black-white terminal, gui for gvim
"setting the position of the cursor
set ruler
"show date and time on status bar
set rulerformat=%55(%{strftime('%a\ %b\ %e\ %I:%M\ %p')}\ %5l,%-6(%c%V%)\ %P%)
"show current entering command
set showcmd
"make the lightline showup in one page vim
set laststatus=2
"scrolling when last five lines in one page
set scrolloff=5
"Setting highlight searching
set hls
"Setting for persistent undo
set undodir=~/.vim/undodir
set undofile
set undolevels=1000 "maximum number of changes that can be undone
set undoreload=10000 "maximum number lines to save for undo on a buffer reload
"Setting for enhanced vim command line completion
set wildmenu wildmode=full
set wildchar=<Tab> wildcharm=<c-z>
"For edit multiple buffers without saving the modifications made to a buffer while loading other buffers
set hidden

"hi Pmenu        term=standout   cterm=reverse   ctermfg=Magenta
hi PmenuSel     term=bold       cterm=bold      ctermfg=Blue  ctermbg=White
"hi PmenuSbar    term=standout   cterm=bold      ctermfg=White  ctermbg=White
hi PmenuThumb   term=bold       cterm=bold
"============================================Setting for Combination with Other Apps=======================================================
"Show the correct color in tmux
if exists('$TMUX')
  set term=screen-256color
endif
"Enabling mouse scroling in iterm2 for vim
set mouse=a
if has("mouse_sgr")
    set ttymouse=sgr
else
    set ttymouse=xterm2
end
"Setting for accepting instruction form xterm-style keys
if &term =~ '^screen' && exists('$TMUX')
    set mouse+=a
    " tmux knows the extended mouse mode
    set ttymouse=xterm2
    " tmux will send xterm-style keys when xterm-keys is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
    execute "set <xHome>=\e[1;*H"
    execute "set <xEnd>=\e[1;*F"
    execute "set <Insert>=\e[2;*~"
    execute "set <Delete>=\e[3;*~"
    execute "set <PageUp>=\e[5;*~"
    execute "set <PageDown>=\e[6;*~"
    execute "set <xF1>=\e[1;*P"
    execute "set <xF2>=\e[1;*Q"
    execute "set <xF3>=\e[1;*R"
    execute "set <xF4>=\e[1;*S"
    execute "set <F5>=\e[15;*~"
    execute "set <F6>=\e[17;*~"
    execute "set <F7>=\e[18;*~"
    execute "set <F8>=\e[19;*~"
    execute "set <F9>=\e[20;*~"
    execute "set <F10>=\e[21;*~"
    execute "set <F11>=\e[23;*~"
    execute "set <F12>=\e[24;*~"
endif
"============================================Abbreviations=======================================================
iabbrev retrun return
iabbrev incldue include
"============================================Mapping==============================================================
let mapleader = "," "other common leader are , - <space> <cr> <bs> H L
let maplocalleader = '\'
"delete one line and pasate it at next line(move downward one row)
noremap - ddp
"delete one line and pasate it above current line(move upward one row)
noremap _ kddpk
"Switch between different window
nmap <silent> <s-right> :wincmd l<cr>
nmap <silent> <s-down> :wincmd j<cr>
nmap <silent> <s-up> :wincmd k<cr>
nmap <silent> <s-left> :wincmd h<cr>
"shortcuts for buffers
nmap <silent> <c-n> :bn<cr>
nmap <silent> <c-p> :bp<cr>
"close current buffer and go to past bufferline
nmap <silent> <leader>c :bp \|bd #<cr>
"open buffer switch menu
nmap <c-b> :b <c-z>
"enter jj to escape insert mode
inoremap jj <esc>
"enter <C-D> to delete one line in insert mode
inoremap <c-d> <esc>d0d$i
"go to the end of one word when typing
ino <c-z> <esc>ei
"edit and source vimrc more quickly when using vim
nnoremap <leader>ev :vs $MYVIMRC<cr>
nn <leader>sv :source $MYVIMRC<cr>
"shortcuts for tab page
nn <c-h> gT
nn <c-l> gt
nn <leader>q :tabdo quit<cr>
"============================================Mapping for Plugin=======================================================
"Toggling for NERDTree
noremap <silent> <c-e> :NERDTreeToggle<cr>
"Toggling for tagbar
nn <silent> <F1> :TagbarToggle<cr>
"============================================AutoCMD==============================================================
"for automatically running or compiling file
autocmd filetype python nn <buffer> <localleader>3 G:read! python3 %<cr>
autocmd filetype python nn <buffer> <localleader>2 G:read! python %<cr>
autocmd filetype c nn <buffer> <localleader>c :!gcc %<cr>
autocmd filetype cpp nn <buffer> <localleader>c :!g++ %<cr>
