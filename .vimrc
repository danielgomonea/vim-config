" This must be set first due to side effects on following properties
set nocompatible

" Load vim-plug
call plug#begin('~/.vim/plugged')

" Tiled Window Management for Vim; fetches https://github.com/spolu/dwm.vim
Plug 'spolu/dwm.vim'

" File tree; fetches https://github.com/scrooloose/nerdtree
Plug 'scrooloose/nerdtree'

" Fuzzy file, buffer, mru, tag, etc finder; fetches https://github.com/kien/ctrlp.vim
Plug 'kien/ctrlp.vim'

" Emmet for vim; fetches https://github.com/mattn/emmet-vim
Plug 'mattn/emmet-vim'

" Change outside tags; fetches https://github.com/tpope/vim-surround
Plug 'tpope/vim-surround'

" Dark theme for VIM; fetches https://github.com/w0ng/vim-hybrid
Plug 'w0ng/vim-hybrid'

" Nunjucks support; fetches https://github.com/mitsuhiko/jinja2
Plug 'mitsuhiko/jinja2'

" Stylus support; fetches https://github.com/wavded/vim-stylus
Plug 'wavded/vim-stylus'

" Javascript support; fetches https://github.com/pangloss/vim-javascript
Plug 'pangloss/vim-javascript'

" jQuery support; fetches https://github.com/itspriddle/vim-jquery
Plug 'itspriddle/vim-jquery'

" Add plugins to &runtimepath
call plug#end()


" Enable indents
filetype plugin indent on

" show existing tab with 4 spaces width
set tabstop=4

" when indenting with '>', use 4 spaces width
set shiftwidth=4

" On pressing tab, insert 4 spaces
set expandtab

" Change the mapleader from \ to ,
let mapleader=","

" Quickly edit/reload the .vimrc
nmap <silent> <leader>ev :e $MYVIMR<CR>
nmap <silent> <leader>sv :so $MYVIMR<CR>

" Hides buffers instead closing them
set hidden

" Don't wrap lines
set nowrap

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start
set autoindent
set copyindent
set number
set shiftround
set showmatch
set ignorecase
set smartcase
set smarttab
set hlsearch
set incsearch

" Buffer settings
set history=100
set undolevels=100
set wildignore=*.swp,*.bak,*.pyc,*.class
set title
set visualbell
set noerrorbells
set nobackup
set noswapfile

" File type plugins
filetype plugin indent on

" Enable syntax highlighting
syntax on

" Enable fuzzy finder 
set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git\|bower_modules'

" Remap : to ; to give up on using shift key
nnoremap ; :

" Open NERDTree if no files are specified at startup
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Colors
set background=dark
colorscheme hybrid

" Enable nunjucks
au BufNewFile,BufRead *.html,*.htm,*.njk,*.nunjucks set ft=jinja

" Set global clipboard
set clipboard=unnamed

