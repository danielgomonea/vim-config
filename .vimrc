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

" Fearch and display information from arbitrary sources; fetches https://github.com/Shougo/unite.vim
Plug 'Shougo/unite.vim'

" Editorconfig support; fetches https://github.com/editorconfig/editorconfig-vim.git
Plug 'editorconfig/editorconfig-vim'

" Emmet for vim; fetches https://github.com/mattn/emmet-vim
Plug 'mattn/emmet-vim'

" Change outside tags; fetches https://github.com/tpope/vim-surround
Plug 'tpope/vim-surround'

" Autoclose tags; fetches https://github.com/Townk/vim-autoclose
Plug 'Townk/vim-autoclose'

" Indent guides; fetches https://github.com/nathanaelkane/vim-indent-guides
Plug 'nathanaelkane/vim-indent-guides'

" Dark theme for VIM; fetches https://github.com/w0ng/vim-hybrid
Plug 'w0ng/vim-hybrid'

" Markdown support; fetches https://github.com/tpope/vim-markdown
Plug 'tpope/vim-markdown'

" Nunjucks support; fetches https://github.com/lepture/vim-jinja
Plug 'lepture/vim-jinja'

" Stylus support; fetches https://github.com/wavded/vim-stylus
Plug 'wavded/vim-stylus'

" Javascript support; fetches https://github.com/pangloss/vim-javascript
Plug 'pangloss/vim-javascript'

" Javascript support; fetches https://github.com/jelera/vim-javascript-syntax
Plug 'jelera/vim-javascript-syntax'

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

" Set global clipboard
set clipboard=unnamed

" Colors
set background=dark
colorscheme hybrid

" Plugin: Fuzzy finder 
set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git\|bower_modules'

" Remap : to ; to give up on using shift key
nnoremap ; :

" Plugin NerdTree
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Plugin: indent guides
set ts=4 sw=4 et
let g:indent_guides_auto_colors = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_color_change_percent = 5
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=3
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=4

" Plugin: Jinja
au BufNewFile,BufRead *.html,*.htm,*.njk,*.nunjucks set ft=jinja


