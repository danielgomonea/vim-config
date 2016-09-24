" -- bootstrap -----------------------------------------------------------------

set encoding=utf-8        " set vim encoding to UTF-8
set term=screen-256color  " set correct color in tmux
set nocompatible    	  " the future is now, use vim defaults instead of vi ones
set nomodeline      	  " disable mode lines (security measure)
set history=1000    	  " boost commands and search patterns history
set undolevels=1000 	  " boost undo levels

" expand filenames with forward slash
if exists("+shellslash")
  set shellslash    
endif

set noshelltemp    		" use pipes instead of temp files for shell commands
set timeoutlen=500 		" time in milliseconds for a key sequence to complete
let mapleader=","  		" change the mapleader from \ to ,
let maplocalleader=","  " change local leader key to ,

" <leader>ev edits .vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<CR>

" <leader>sv sources .vimrc
nnoremap <leader>sv :source $MYVIMRC<CR>:runtime! plugin/settings/*<CR>:redraw<CR>:echo $MYVIMRC 'reloaded'<CR>
 
if has ('autocmd') " Remain compatible with earlier versions
 augroup vimrc     " Source vim configuration upon save
    autocmd! BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw
    autocmd! BufWritePost $MYGVIMRC if has('gui_running') | so % | echom "Reloaded " . $MYGVIMRC | endif | redraw
  augroup END
endif " has autocmd


" remap : to ; to give up on using shift key
nnoremap ; :

" do sudo if write if using !!
cmap w!! w !sudo tee % >/dev/null

" enable mouse scrolling
set mouse=a

" -- backup and swap files -----------------------------------------------------

set backup      " enable backup files
set writebackup " enable backup files
set swapfile    " enable swap files (useful when loading huge files)

let s:vimdir=$HOME . "/.vim"
let &backupdir=s:vimdir . "/backup"  " backups location
let &directory=s:vimdir . "/tmp"     " swap location

if exists("*mkdir")
  if !isdirectory(s:vimdir)
    call mkdir(s:vimdir, "p")
  endif
  if !isdirectory(&backupdir)
    call mkdir(&backupdir, "p")
  endif
  if !isdirectory(&directory)
    call mkdir(&directory, "p")
  endif
endif

set backupskip+=*.tmp " skip backup for *.tmp

if has("persistent_undo")
  let &undodir=&backupdir
  set undofile  " enable persistent undo
endif

let &viminfo=&viminfo . ",n" . s:vimdir . "/.viminfo" " viminfo location


" -- file type detection -------------------------------------------------------

" Enable indents
filetype on         " /!\ doesn't play well with compatible mode
filetype plugin on  " trigger file type specific plugins
filetype indent on  " indent based on file type syntax


" -- command mode --------------------------------------------------------------

set wildmenu                        " enable tab completion menu
set wildmode=longest:full,full      " complete till longest common string, then full
set wildignore+=.git                " ignore the .git directory
set wildignore+=*.DS_Store          " ignore Mac finder/spotlight crap
set wildignore+=node_modules        " ignore the node_modules directory
set wildignore+=bower_components    " ignore the bower_components directory
set wildignore+=www    				" ignore the www directory

if exists ("&wildignorecase")
  set wildignorecase
endif

" CTRL+A moves to start of line in command mode
cnoremap <C-a> <home>
" CTRL+E moves to end of line in command mode
cnoremap <C-e> <end>

" CTRL+C closes the command window
if has("autocmd")
  augroup command
    autocmd!
    autocmd CmdwinEnter * noremap <buffer> <silent> <C-c> <ESC>:q<CR>
  augroup END
endif


" -- display -------------------------------------------------------------------

set title       " change the terminal title
set lazyredraw  " do not redraw when executing macros
set report=0    " always report changes
set cursorline  " highlight current line

" resize splits when the window is resized
if has("autocmd")
  augroup vim
    autocmd!
    autocmd filetype vim set textwidth=80
  augroup END
  augroup windows
    autocmd!
    autocmd VimResized * :wincmd = 
  augroup END
endif

" highlight current column
if has("gui_running")
  set cursorcolumn
endif

set number							  " number column
set numberwidth=3   				  " narrow number column

set nolist                            " hide unprintable characters
if has("multi_byte")                  " if multi_byte is available,
  set listchars=eol:¬,tab:▸\ ,trail:⌴ " use pretty Unicode unprintable symbols
else                                  " otherwise,
  set listchars=eol:$,tab:>\ ,trail:. " use ASCII characters
endif

" temporarily disable unprintable characters when entering insert mode
if has("autocmd")
  augroup list
    autocmd!
    autocmd InsertEnter * let g:restorelist=&list | :set nolist
    autocmd InsertLeave * let &list=g:restorelist
  augroup END
endif

" inverts display of unprintable characters
nnoremap <silent> <leader>l :set list! list?<CR>

set noerrorbells      " shut up
set visualbell t_vb=  " use visual bell instead of error bell
set mousehide         " hide mouse pointer when typing


" Tabs only if there are at least two tabs (default)
if exists("+showtabline")
  set showtabline=1 "
endif

" Status line config
if has("statusline")

  function! StatusLineUTF8()
    try
      let p = getpos('.')
      redir => utf8seq
      sil normal! g8
      redir End
      call setpos('.', p)
      return substitute(matchstr(utf8seq, '\x\+ .*\x'), '\<\x\x', '0x\U&', 'g')
    catch
      return '?'
    endtry
  endfunction

  function! StatusLineFileEncoding()
    return has("multi_byte") && strlen(&fenc) ? &fenc : ''
  endfunction

  function! StatusLineUTF8Bomb()
    return has("multi_byte") && &fenc == 'utf-8' && &bomb?'+bomb' : ''
  endfunction

  function! StatusLineCWD()
    let l:pwd = exists('$PWD') ? $PWD : getcwd()
    return substitute(fnamemodify(l:pwd, ':~'), '\(\~\?/[^/]*/\).*\(/.\{20\}\)', '\1...\2', '')
  endfunction

  set laststatus=2  " always show a status line
  " set exact status line format
  set statusline=
  set statusline+=%#Number#
  set statusline+=●\ %02n                        " buffer number
  set statusline+=\ \|\                          " separator
  set statusline+=%*
  set statusline+=%#Identifier#
  set statusline+=%f                             " file path relative to CWD
  set statusline+=%*
  set statusline+=%#Special#
  set statusline+=%m                             " modified flag
  set statusline+=%#Statement#
  set statusline+=%r                             " readonly flag
  set statusline+=%h                             " help buffer flag
  set statusline+=%w                             " preview window flag
  set statusline+=%#Type#
  set statusline+=\ \[%{&ff}]                       " file format
  set statusline+=[
  set statusline+=%{StatusLineFileEncoding()}    " file encoding
  set statusline+=%#Error#
  set statusline+=%{StatusLineUTF8Bomb()}        " UTF-8 bomb alert
  set statusline+=%#Type#
  set statusline+=]
  set statusline+=%y                             " type of file
  set statusline+=\ \|\                          " separator
  set statusline+=%*
  set statusline+=%#Directory#
  set statusline+=%{StatusLineCWD()}             " current working directory
  set statusline+=\                              " separator
  set statusline+=%*
  set statusline+=%=                             " left / right items separator
  set statusline+=%#Comment#
  set statusline+=%{v:register}                  " current register in effect
  set statusline+=\                              " separator
  set statusline+=%#Statement#
  set statusline+=\ \|\                          " separator
  set statusline+=%#Comment#
  set statusline+=line\ %5l/%L\                  " line number / number of lines
  set statusline+=●\ %02p%%,\                    " percentage through file
  set statusline+=col\ %3v                       " column number
endif

set showcmd      	   " show partial command line (default)
set cmdheight=1 	   " height of the command line

set shortmess=astT     " abbreviate messages
set shortmess+=I       " disable the welcome screen

if (&t_Co > 2 || has("gui_running")) && has("syntax")
   syntax on  " turn syntax highlighting on, when terminal has colors or in GUI
endif

if has("gui_running")  " GUI mode
  set guioptions-=T    " remove useless toolbar
  set guioptions+=c    " prefer console dialogs to popups
endif

" ease reading in GUI mode by inserting space between lines
set linespace=2

" code folding
if has("folding")
  set foldenable        " enable folding
  set foldmethod=syntax " fold based on syntax highlighting
  set foldlevelstart=99 " start editing with all folds open

  " toggle folds
  nnoremap <Space> za
  vnoremap <Space> za

  set foldtext=FoldText()
  function! FoldText()
    let l:lpadding = &fdc
    redir => l:signs
      execute 'silent sign place buffer='.bufnr('%')
    redir End
    let l:lpadding += l:signs =~ 'id=' ? 2 : 0

    if exists("+relativenumber")
      if (&number)
        let l:lpadding += max([&numberwidth, strlen(line('$'))]) + 1
      elseif (&relativenumber)
        let l:lpadding += max([&numberwidth, strlen(v:foldstart) + strlen(v:foldstart - line('w0')), strlen(v:foldstart) + strlen(line('w$') - v:foldstart)]) + 1
      endif
    else
      if (&number)
        let l:lpadding += max([&numberwidth, strlen(line('$'))]) + 1
      endif
    endif

    " expand tabs
    let l:start = substitute(getline(v:foldstart), '\t', repeat(' ', &tabstop), 'g')
    let l:end = substitute(substitute(getline(v:foldend), '\t', repeat(' ', &tabstop), 'g'), '^\s*', '', 'g')

    let l:info = ' (' . (v:foldend - v:foldstart) . ')'
    let l:infolen = strlen(substitute(l:info, '.', 'x', 'g'))
    let l:width = winwidth(0) - l:lpadding - l:infolen

    let l:separator = ' … '
    let l:separatorlen = strlen(substitute(l:separator, '.', 'x', 'g'))
    let l:start = strpart(l:start , 0, l:width - strlen(substitute(l:end, '.', 'x', 'g')) - l:separatorlen)
    let l:text = l:start . ' … ' . l:end

    return l:text . repeat(' ', l:width - strlen(substitute(l:text, ".", "x", "g"))) . l:info
  endfunction
endif

" Highlight SCM merge conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'


" -- buffers -------------------------------------------------------------------

set nobomb            " don't clutter files with Unicode BOMs
set hidden            " enable switching between buffers without saving
set switchbuf=usetab  " switch to existing tab then window when switching buffer
set autoread          " auto read files changed only from the outside of ViM
if has("persistent_undo") && (&undofile)
  set autowriteall    " auto write changes if persistent undo is enabled
endif
set fsync             " sync after write
set confirm           " ask whether to save changed files

if has("autocmd")
  augroup trailing_spaces
    autocmd!
    "autocmd BufWritePre * :%s/\s\+$//e " remove trailing spaces before saving
  augroup END
  augroup restore_cursor
    " restore cursor position to last position upon file reopen
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal! g`\"" | endif
  augroup END
endif

" cd to the directory of the current buffer
nnoremap <silent> <leader>cd :cd %:p:h<CR>

" switch between last two files
nnoremap <leader><Tab> <c-^>

" <leader>w writes the whole buffer to the current file
nnoremap <silent> <leader>w :w!<CR>
inoremap <silent> <leader>w <ESC>:w!<CR>

" <leader>W writes all buffers
nnoremap <silent> <leader>W :wa!<CR>
inoremap <silent> <leader>W <ESC>:wa!<CR>


" -- navigation ----------------------------------------------------------------

" move to first non-whitespace character of line (when not using mac keyboard)
noremap H ^
" move to end of line (when not using mac keyboard)
noremap L g_

" scroll slightly faster
nnoremap <C-e> 2<C-e>
nnoremap <C-y> 2<C-y>
map <C-Up> <C-y>
map <C-Down> <C-e>

set startofline " move to first non-blank of the line when using PageUp/PageDown

" scroll by visual lines, useful when wrapping is enabled
nnoremap j gj
nnoremap <Down> gj
nnoremap k gk
nnoremap <Up> gk

set scrolljump=1    " minimal number of lines to scroll vertically
set scrolloff=4     " number of lines to keep above and below the cursor
                    "   typing zz sets current line at the center of window
set sidescroll=1    " minimal number of columns to scroll horizontally
set sidescrolloff=4 " minimal number of columns to keep around the cursor

if has("vertsplit")
  " split current window vertically
  nnoremap <leader>_ <C-w>v<C-w>l
  set splitright  " when splitting vertically, split to the right
endif
if has("windows")
  " split current window horizontally
  nnoremap <leader>- <C-w>s
  set splitbelow  " when splitting horizontally, split below
endif

" move cursor wihout leaving insert mode
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

" create a new tab
nnoremap <silent> <leader>t :tabnew<CR>

set whichwrap=b,s,<,> " allow cursor left/right key to wrap to the
                      " previous/next line
                      " omit [,] as we use virtual edit in insert mode
					  
" move to the position where the last change was made
noremap gI `.


" -- editing -------------------------------------------------------------------

set showmode      " always show the current editing mode
set linebreak     " yet if enabled break at word boundaries

if has("multi_byte")  " if multi_byte is available,
  set showbreak=↪     " use pretty Unicode marker
else                  " otherwise,
  set showbreak=>     " use ASCII character
endif

set nojoinspaces  " insert only one space after '.', '?', '!' when joining lines
set showmatch     " briefly jumps the cursor to the matching brace on insert
set matchtime=4   " blink matching braces for 0.4s

set matchpairs+=<:>         " make < and > match
runtime macros/matchit.vim  " enable extended % matching

set virtualedit=insert    " allow the cursor to go everywhere (insert)
set virtualedit+=onemore  " allow the cursor to go just past the end of line
set virtualedit+=block    " allow the cursor to go everywhere (visual block)

set backspace=indent,eol,start " allow backspacing over everything (insert)

set expandtab     " insert spaces instead of tab, CTRL-V+Tab inserts a real tab
set tabstop=4     " 1 tab == 2 spaces
set softtabstop=4 " number of columns used when hitting TAB in insert mode
set smarttab      " insert tabs on the start of a line according to shiftwidth

if has("autocmd")
  augroup makefile
    autocmd!
    " don't expand tab to space in Makefiles
    autocmd filetype make setlocal noexpandtab
  augroup END
endif

set autoindent    " enable autoindenting
set copyindent    " copy the previous indentation on autoindenting
set shiftwidth=4  " indent with 2 spaces
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
			  
" make Y consistent with C and D by yanking up to end of line
noremap Y y$

" CTRL-S saves file
"nnoremap <C-s> :w<CR>

" inverts paste mode (no formatting)
nnoremap <silent> <leader>pp :set paste! paste?<CR>
" same in insert mode
set pastetoggle=<leader>pp

" <leader>rt retabs the file, preserve cursor position
nnoremap <silent> <leader>rt :call Preserve(":retab")<CR>

" <leader>s removes trailing spaces
noremap <silent> <leader>s :call Preserve("%s/\\s\\+$//e")<CR>

" <leader>$ fixes mixed EOLs (^M)
noremap <silent> <leader>$ :call Preserve("%s/<C-V><CR>//e")<CR>

" use <leader>d to delete a line without adding it to the yanked stack
nnoremap <silent> <leader>d "_d
vnoremap <silent> <leader>d "_d

" use <leader>c to replace text without yanking replaced text
nnoremap <silent> <leader>c "_c
vnoremap <silent> <leader>c "_c

" yank/paste to/from the OS clipboard
map <silent> <leader>y "+y
map <silent> <leader>Y "+Y
map <silent> <leader>p "+p
map <silent> <leader>P "+P

" paste without yanking replaced text in visual mode
vnoremap <silent> p "_dP
vnoremap <silent> P "_dp

" always share the OS clipboard
set clipboard+=unnamed

" autofix typos (the)
iabbrev teh the

" exit from insert mode without cursor movement
inoremap jk <ESC>`^

" quick insertion of newline in normal mode with <CR>
if has("autocmd")
  nnoremap <silent> <CR> :put=''<CR>
  augroup newline
    autocmd!
    autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
    autocmd CmdwinEnter * nnoremap <buffer> <CR> <CR>
  augroup END
endif

" remap U to <C-r> for easier redo
nnoremap U <C-r>

" preserve cursor position when joining lines
nnoremap J :call Preserve("normal! J")<CR>

" split line and preserve cursor position
nnoremap S :call Preserve("normal! i\r")<CR>

" select what was just pasted
nnoremap <leader>v V`]

" <C-Space> triggers completion in insert mode
inoremap <C-Space> <C-P>
if !has("gui_running")
  inoremap <C-@> <C-P>
endif

set completeopt=longest,menuone,preview " better completion

" move current line down
noremap <silent>- :m+<CR>
" move current line up
noremap <silent>_ :m-2<CR>
" move visual selection down
vnoremap <silent>- :m '>+1<CR>gv=gv
" move visual selection up
vnoremap <silent>_ :m '<-2<CR>gv=gv

" make dot work in visual mode
vnoremap . :normal .<CR>


" -- searching -----------------------------------------------------------------

set wrapscan    " wrap around when searching
set incsearch   " show match results while typing search pattern

if (&t_Co > 2 || has("gui_running"))
  set hlsearch  " highlight search terms
endif

" temporarily disable highlighting when entering insert mode
if has("autocmd")
  augroup hlsearch
    autocmd!
    autocmd InsertEnter * let g:restorehlsearch=&hlsearch | :set nohlsearch
    autocmd InsertLeave * let &hlsearch=g:restorehlsearch
  augroup END
endif

" unset the "last search pattern" register by hitting return
nnoremap <CR> :let @/ = ""<CR><CR>

set ignorecase  " case insensitive search
set smartcase   " case insensitive only if search pattern is all lowercase
                "   (smartcase requires ignorecase)
set gdefault    " search/replace globally (on a line) by default

" highlight all instances of the current word where the cursor is positioned
nnoremap <silent> <leader>hs :setl hls<CR>:let @/="\\<<C-r><C-w>\\>"<CR>

" replace word under cursor
nnoremap <leader>; :%s/\<<C-r><C-w>\>//<Left>

function! BlinkMatch(t)
    let [l:bufnum, l:lnum, l:col, l:off] = getpos('.')
    let l:current = '\c\%#'.@/
    let l:highlight = matchadd('IncSearch', l:current, 1000)
    redraw
    exec 'sleep ' . float2nr(a:t * 1000) . 'm'
    call matchdelete(l:highlight)
    redraw
endfunction

" center screen on next/previous match, blink current match
noremap <silent> n nzzzv:call BlinkMatch(0.2)<CR>
noremap <silent> N Nzzzv:call BlinkMatch(0.2)<CR>

function! GetVisualSelection()
  let [l:l1, l:c1] = getpos("'<")[1:2]
  let [l:l2, l:c2] = getpos("'>")[1:2]
  let l:selection = getline(l:l1, l:l2)
  let l:selection[-1] = l:selection[-1][: l:c2 - 1]
  let l:selection[0] = l:selection[0][l:c1 - 1:]
  return join(l:selection, "\n")
endfunction

" search for visually selected areas
xnoremap * <ESC>/<C-r>=substitute(escape(GetVisualSelection(), '\/.*$^~[]'), "\n", '\\n', "g")<CR><CR>
xnoremap # <ESC>?<C-r>=substitute(escape(GetVisualSelection(), '\/.*$^~[]'), "\n", '\\n', "g")<CR><CR>

" prepare search based on visually selected area
xnoremap / <ESC>/<C-r>=substitute(escape(GetVisualSelection(), '\/.*$^~[]'), "\n", '\\n', "g")<CR>

" prepare substitution based on visually selected area
xnoremap & <ESC>:%s/<C-r>=substitute(escape(GetVisualSelection(), '\/.*$^~[]'), "\n", '\\n', "g")<CR>/


" -- spell checking ------------------------------------------------------------

set spelllang=en  " English only
set nospell       " disabled by default

if has("autocmd")
  augroup spell
    autocmd!
    "autocmd filetype vim setlocal spell " enabled when editing .vimrc
  augroup END
endif

" -- plugins -------------------------------------------------------------------

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

" Add plugins to &runtimepath
call plug#end()

" Plugin: Unite
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


" -- themes -------------------------------------------------------------------

set background=dark
colorscheme hybrid
