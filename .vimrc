"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maintainer: 
"       Zeno Popopvici (Graffino)
"       zeno@graffino.com
"		http://apps.graffino.com
"
" Version: 
"       1.0 - 26/09/2016
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Bootstrap
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set encoding=utf-8        " Set vim encoding to UTF-8
set ffs=unix,dos,mac	  " Use unix as standard file type
set term=screen-256color  " Set correct color (fixes color while in tmux)

set nocompatible    	  " Use vim defaults instead of vi ones
set nomodeline      	  " Disable mode lines (security measure)

set history=1000    	  " Boost commands and search patterns history
set undolevels=1000 	  " Boost undo levels

let mapleader=","  		  " Change the mapleader from \ to ,
let maplocalleader=","    " Change local leader key to ,

" Remap : to ; (for usage without shift key)
nnoremap ; : 			 

" Do sudo before writting if using !!
cmap w!! w !sudo tee % >/dev/null

set noshelltemp    		   " Use pipes instead of temp files for shell commands
set timeoutlen=500 		   " Time in milliseconds for a key sequence to complete

" Fast editing and auto-reloading of vimrc configs
map <leader>e :e! ~/.vimrc<cr>
autocmd! BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Backup, swap, history
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Turn backup off, since most stuff is in SVN, git et.c anyway.
set nobackup
set nowb
set noswapfile

" Enable persistent undo
set undodir=~/.vim/undo
set undofile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Command mode
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable command line completion
set wildmenu
set wildmode=longest:full,full      " Complete till longest common string, then full
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store/*,*/node_modules/*,*/bower_components/*,*/www
set wildignorecase					" Ignore case

" CTRL+C closes the command window
autocmd CmdwinEnter * noremap <buffer> <silent> <C-c> <ESC>:q<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Editing
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set showmode      	  		" Always show the current editing mode
set linebreak         		" Yet if enabled break at word boundaries

" If multi_byte is available, use pretty Unicode marker
if has("multi_byte")  
  set showbreak=↪
else
  set showbreak=>
endif

" For regular expressions turn magic on
set magic

set nojoinspaces  	  		" Insert only one space after '.', '?', '!' when joining lines
set showmatch     	  		" Briefly jumps the cursor to the matching brace on insert
set matchtime=4   	  	    " Blink matching braces for 0.4s
set matchpairs+=<:>         " Make < and > match
runtime macros/matchit.vim  " Enable extended % matching

set virtualedit=insert    	" Allow the cursor to go everywhere (insert)
set virtualedit+=onemore  	" Allow the cursor to go just past the end of line
set virtualedit+=block    	" Allow the cursor to go everywhere (visual block)

" Allow backspacing over everything (insert)
set backspace=indent,eol,start	

set expandtab     			" Insert spaces instead of tab, CTRL-V+Tab inserts a real tab
set tabstop=4     			" 1 tab = 4 spaces
set softtabstop=4 			" Number of columns used when hitting TAB in insert mode
set smarttab      			" Insert tabs on the start of a line according to shiftwidth

set autoindent    			" Enable autoindenting
set copyindent    			" Copy the previous indentation on autoindenting
set shiftwidth=4  			" Indent with 4 spaces
set shiftround    			" Use multiple of shiftwidth when indenting with '<' and '>'

" Better completion
set completeopt=longest,menuone,preview 

" Move current line down
noremap <silent>- :m+<CR>

" Move current line up
noremap <silent>_ :m-2<CR>

"Move visual selection down
vnoremap <silent>- :m '>+1<CR>gv=gv

"Move visual selection down
vnoremap <silent>_ :m '<-2<CR>gv=gv

" CTRL-S saves file
"nnoremap <C-s> :w<CR>

" Remap U to <CTRL-r> for easier redo
nnoremap U <C-r>

" Make dot work in visual mode
vnoremap . :normal .<CR>

" Exit from insert mode without cursor movement
inoremap jk <ESC>`^

" Preserve cursor position when joining lines
nnoremap J :call Preserve("normal! J")<CR>

" Split line and preserve cursor position
nnoremap S :call Preserve("normal! i\r")<CR>

" <leader>rt retabs the file, preserve cursor position
nnoremap <silent> <leader>rt :call Preserve(":retab")<CR>

" <leader>$ fixes mixed EOLs (^M)
noremap <silent> <leader>$ :call Preserve("%s/<C-V><CR>//e")<CR>			  


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Editing - Autoreplace
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Autofix typos (the)
iabbrev teh the


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Editing - Copy & Paste
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Make Y consistent with C and D by yanking up to end of line
noremap Y y$

" Toggle paste mode on and off
nnoremap <silent> <leader>pp :set paste! paste?<CR>
set pastetoggle=<leader>pp

" use <leader>d to delete a line without adding it to the yanked stack
nnoremap <silent> <leader>d "_d
vnoremap <silent> <leader>d "_d

" use <leader>c to replace text without yanking replaced text
nnoremap <silent> <leader>c "_c
vnoremap <silent> <leader>c "_c

" Yank/paste to/from the OS clipboard
map <silent> <leader>y "+y
map <silent> <leader>Y "+Y
map <silent> <leader>p "+p
map <silent> <leader>P "+P

" Paste without yanking replaced text in visual mode
vnoremap <silent> p "_dP
vnoremap <silent> P "_dp

" Always share the OS clipboard
set clipboard+=unnamed

" Select what was just pasted using <leader>v
nnoremap <leader>v V`]


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nobomb            				 " Don't clutter files with Unicode BOMs
set hidden            				 " Enable switching between buffers without saving
set switchbuf=usetab  				 " Switch to existing tab then window when switching buffer
set autoread          				 " Auto read files changed only from the outside of ViM

if has("persistent_undo") && (&undofile)
  set autowriteall    				 " Auto write changes if persistent undo is enabled
endif
set fsync             				 " Sync after write
set confirm           				 " Ask whether to save changed files

" Remove trailing spaces before saving
" autocmd BufWritePre * :%s/\s\+$//e

" Restore cursor position to last position upon file reopen
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal! g`\"" | endif

" CD to the directory of the current buffer
nnoremap <silent> <leader>cd :cd %:p:h<CR>

" Switch between last two files
nnoremap <leader><Tab> <c-^>

" <leader>w writes the whole buffer to the current file
nnoremap <silent> <leader>w :w!<CR>
inoremap <silent> <leader>w <ESC>:w!<CR>

" <leader>W writes all buffers
nnoremap <silent> <leader>W :wa!<CR>
inoremap <silent> <leader>W <ESC>:wa!<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Navigation
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Move to first non-blank of the line when using PageUp/PageDown
set startofline 		

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove 

" Create a new tab
nnoremap <silent> <leader>t :tabnew<CR>
					  
" Move to the position where the last change was made
noremap gI `.

" Allow cursor left/right key to wrap to the previous/next line, omit [,] as we use virtual edit in insert mode
set whichwrap=b,s,<,>

" Move cursor wihout leaving insert mode
try
  redir => s:backspace
  silent! execute 'set ' 't_kb?'
  redir END
  if s:backspace !~ '\^H'
    inoremap <C-h> <C-o>h
    inoremap <C-j> <C-o>j
    inoremap <C-k> <C-o>k
    inoremap <C-l> <C-o>l
  endif
finally
  redir END
endtry


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Navigation - Scrolling
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable mouse scrolling
set mouse=a

set scrolljump=1    	" Minimal number of lines to scroll vertically
set scrolloff=4     	" Number of lines to keep above and below the cursor
set sidescroll=1    	" Minimal number of columns to scroll horizontally
set sidescrolloff=4 	" Minimal number of columns to keep around the cursor

" Scroll by visual lines, useful when wrapping is enabled
nnoremap j gj
nnoremap <Down> gj
nnoremap k gk
nnoremap <Up> gk

" Scroll slightly faster
nnoremap <C-e> 2<C-e>
nnoremap <C-y> 2<C-y>
map <C-Up> <C-y>
map <C-Down> <C-e>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Navigation - Searching
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set wrapscan    			" Wrap around when searching
set ignorecase  			" Case insensitive search
set smartcase   			" Case insensitive only if search pattern is all lowercase (smartcase requires ignorecase)
set gdefault    			" Search/replace globally (on a line) by default
set incsearch  			 	" Show match results while typing search pattern

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /
map <c-space> ?

" Replace word under cursor
nnoremap <leader>; :%s/\<<C-r><C-w>\>//<Left>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Navigation - Searching - Highlighting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set hlsearch  				" Highlight search terms

" Highlight all instances of the current word where the cursor is positioned
nnoremap <silent> <leader>hs :setl hls<CR>:let @/="\\<<C-r><C-w>\\>"<CR>

" Temporarily disable highlighting when entering insert mode
if has("autocmd")
  augroup hlsearch
    autocmd!
    autocmd InsertEnter * let g:restorehlsearch=&hlsearch | :set nohlsearch
    autocmd InsertLeave * let &hlsearch=g:restorehlsearch
  augroup END
endif

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

function! BlinkMatch(t)
    let [l:bufnum, l:lnum, l:col, l:off] = getpos('.')
    let l:current = '\c\%#'.@/
    let l:highlight = matchadd('IncSearch', l:current, 1000)
    redraw
    exec 'sleep ' . float2nr(a:t * 1000) . 'm'
    call matchdelete(l:highlight)
    redraw
endfunction

" Center screen on next/previous match, blink current match
noremap <silent> n nzzzv:call BlinkMatch(0.2)<CR>
noremap <silent> N Nzzzv:call BlinkMatch(0.2)<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Navigation - Spellchecking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set spelllang=en  " English only
set nospell       " disabled by default

" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Display
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set font according to system
set gfn=Operator\ Mono:h14,Hack:h14,Source\ Code\ Pro:h15,Menlo:h15

set shortmess=astT     					" Abbreviate messages
set shortmess+=I       					" Disable the welcome screen

set guioptions-=T    					" Remove useless toolbar
set guioptions+=c    					" Prefer console dialogs to popups
set guioptions-=e						" Extra colors

set title       						" Change the terminal title
set showtabline=1 						" Tabs only if there are at least two tabs (default)

set lazyredraw  						" Do not redraw when executing macros
set report=0    						" Always report changes

set noerrorbells      					" Shut up
set visualbell t_vb=  					" Use visual bell instead of error bell

set cursorline 						    " Highlight current line
set cursorcolumn						" Highlight current column

set number							  	" Number column
set numberwidth=3   				 	" Narrow number column

set nolist                            	" Hide unprintable characters
set mousehide         					" Hide mouse pointer when typing

set showcmd      	   					" Show partial command line (default)
set cmdheight=1 	   					" Height of the command line

" always show a status line
set laststatus=2

" Turn syntax highlighting on
syntax on  								

" Set line spacing
set linespace=2

" Highlight SCM merge conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Display - Unprintable
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" If multi_byte is available, use pretty Unicode unprintable symbols
if has("multi_byte")                  
  set listchars=eol:¬,tab:▸\ ,trail:⌴
else
  set listchars=eol:$,tab:>\ ,trail:.
endif

" Temporarily disable unprintable characters when entering insert mode
if has("autocmd")
  augroup list
    autocmd!
    autocmd InsertEnter * let g:restorelist=&list | :set nolist
    autocmd InsertLeave * let &list=g:restorelist
  augroup END
endif

" Inverts display of unprintable characters
nnoremap <silent> <leader>l :set list! list?<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Display - Code folding
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set foldenable        			" Enable folding
set foldmethod=syntax 			" Fold based on syntax highlighting
set foldlevelstart=99 			" Start editing with all folds open
set foldcolumn=1				" Add extra bit of margin to the left

" Toggle folds
nnoremap <Space> za
vnoremap <Space> za


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Display - File type detection
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

filetype on        				 " Enable detection
filetype plugin on  			 " Trigger file type specific plugins
filetype indent on  			 " Indent based on file type syntax


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Load vim-plug
call plug#begin('~/.vim/plugged')

" Tiled Window Management for Vim; fetches https://github.com/spolu/dwm.vim
Plug 'spolu/dwm.vim'

" File tree; fetches https://github.com/scrooloose/nerdtree
Plug 'scrooloose/nerdtree'

" Aynchronous execution library; fetches https://github.com/Shougo/vimproc.vim
Plug 'Shougo/vimproc.vim', {'do' : 'make'}

" Fearch and display information from arbitrary sources; fetches https://github.com/Shougo/unite.vim
Plug 'Shougo/unite.vim'

" The fastest way to navigate your files; fetches https://github.com/rstacruz/vim-fastunite
Plug 'rstacruz/vim-fastunite'

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

" Git gutter support; fetches https://github.com/airblade/vim-gitgutter.git
Plug 'airblade/vim-gitgutter'

" Status bar support; fetches https://github.com/vim-airline/vim-airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Aligns =; fetches https://github.com/godlygeek/tabular.git
Plug 'godlygeek/tabular'

" Add plugins to &runtimepath
call plug#end()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins - Unite
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Install `brew install the_silver_searcher`
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
let g:unite_source_rec_async_command= 'ag --nocolor --nogroup --hidden -g ""'

map <C-p> [unite]p
nnoremap <space>/ :Unite grep:.<cr>
nnoremap <space>e :Unite -no-split -buffer-name=buffer -quick-match buffer<cr>
let g:unite_enable_split_vertically = 0
let g:unite_winheight = 30
let g:unite_data_directory = '~/.vim/tmp/unite/'
let g:unite_source_grep_default_opts = '--column --no-color --nogroup --with-filename'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins - Indent guides
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set ts=4 sw=4 et
let g:indent_guides_auto_colors = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_color_change_percent = 5
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=3
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=4


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins - Jinja
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin: Jinja
au BufNewFile,BufRead *.html,*.htm,*.njk,*.nunjucks set ft=jinja


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins - Airline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:airline#extensions#tabline#enabled = 1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins - Tablularize
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if exists(":Tabularize")
  nmap <Leader>a= :Tabularize /=<CR>
  vmap <Leader>a= :Tabularize /=<CR>
  nmap <Leader>a: :Tabularize /:\zs<CR>
  vmap <Leader>a: :Tabularize /:\zs<CR>
endif

	
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Themes & colors
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set background=dark
colorscheme hybrid
