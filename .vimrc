setl keywordprg=:help

filetype plugin indent on

" Leader
let mapleader = "-"

set clipboard=unnamed

set noerrorbells                " No beeps
set backspace=indent,eol,start  " Makes backspace key more powerful.
set showcmd                     " Show me what I'm typing

set noswapfile                  " Don't use swapfile
set nobackup		        " Don't create annoying backup files
set nowritebackup

set splitright                  " Split vertical windows right to the current windows
set splitbelow                  " Split horizontal windows below to the current windows
set encoding=utf-8              " Set default encoding to UTF-8

set autowrite                   " Automatically save before :next, :make etc.
set autoread                    " Automatically reread changed files without asking me anything

set laststatus=2  		" Always display the status line
set ruler         " show the cursor position all the time
set hidden

au FocusLost * :wa              " Set vim to save the file on focus out.
set fileformats=unix,dos,mac    " Prefer Unix over Windows over OS 9 formats

set incsearch                   " Shows the match while typing
set hlsearch                    " Highlight found searches
set ignorecase                  " Search case insensitive...
set smartcase                   " ... but not when search pattern contains upper case characters

set lazyredraw          	      " Wait to redraw

" Faster syntax highlighting:
" https://vim.fandom.com/wiki/Fix_syntax_highlighting
set nocursorcolumn
set nocursorline
syntax sync minlines=256
set synmaxcol=300
set re=1

" do not hide markdown
set conceallevel=0

" Make Vim to handle long lines nicely.
set wrap
set textwidth=80
set formatoptions=qrn1

" Do not use relative numbers to where the cursor is.
set norelativenumber

" Apply the indentation of the current line to the next line.
set autoindent
set smartindent
set showmatch
set smarttab

set tabstop=2
set shiftwidth=2
set expandtab
set nrformats-=octal
set shiftround

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \ exe "normal! g`\"" |
      \ endif

set background=dark
let g:solarized_termcolors=256
let g:solarized_termtrans=1

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag -Q -l --nocolor --hidden -g "" %s'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

  if !exists(":Ag")
    command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
    nnoremap \ :Ag<SPACE>
  endif
endif
 
" Switch between the last two files
nnoremap <leader><leader> <c-^>

" vv to generate new vertical split
nnoremap <silent> vv <C-w>v

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Disable arrow movement, resize splits instead.
nnoremap <Up>    :resize +10<CR>
nnoremap <Down>  :resize -10<CR>
nnoremap <Left>  :vertical resize -10<CR>
nnoremap <Right> :vertical resize +10<CR>

" Map Shift + arrow keys to move between tab
nnoremap <S-Up>     :tabr<CR>
nnoremap <S-Down>   :tabl<CR>
nnoremap <S-Right>  :tabn<CR>
nnoremap <S-Left>   :tabp<CR>

" And then do that even in INSERT mode
inoremap <S-Up>    <C-[>:tabr<CR>
inoremap <S-Down>  <C-[>:tabl<CR>
inoremap <S-Right> <C-[>:tabn<CR>
inoremap <S-Left>  <C-[>:tabp<CR>

" <C-w> T opens current split to new tab window
nnoremap <Leader>T <C-w>T

" Remap Jump keys
nnoremap <C-p> <C-o>
nnoremap <C-n> <C-i>

" Move back via tags
nnoremap ] <C-]>
nnoremap [ <C-t>

" Quit all other splits other than current split window
nnoremap <Leader>q  :only<CR>

" edit/reload vimrc
nnoremap <Leader>ve :vsplit $MYVIMRC<CR>
nnoremap <Leader>vr :so $MYVIMRC<CR>

" edit tmux.conf
nnoremap <Leader>te :vsplit $MYTMUXCONF<CR>
nnoremap <Leader>ze :vsplit $MYZSHCONF<CR>

" To make tmux vim shift + arrow work
" Make Vim recognize XTerm escape sequences for Page and Arrow
" keys combined with modifiers such as Shift, Control, and Alt.
" See http://www.reddit.com/r/vim/comments/1a29vk/_/c8tze8p
if &term =~ '^screen'
  " Arrow keys http://unix.stackexchange.com/a/34723
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif

" NerdTree plugin confs
nnoremap <Leader>n :NERDTreeFind<CR>
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeQuitOnOpen = 1
let NERDTreeShowHidden=1

" vim-airline plugin confs
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

" FZF plugin confs
nnoremap <Leader>f/ :Files<CR>
nnoremap <Leader>b/ :BLines<CR>
nnoremap <Leader>t/ :Tags<CR>
nnoremap <Leader>:/ :History:<CR>

" go confs
nnoremap <Leader>gr :GoRun<space>
nnoremap <Leader>gb :GoBuild<space>
nnoremap <Leader>gt :GoTest<space>
nnoremap <Leader>gd :GoDoc<space>
nnoremap <Leader>gi :GoImport<space>
nnoremap <Leader>gri :GoDrop<space>
nnoremap <Leader>gd :GoDef<CR>

" vimux confs
let g:VimuxOrientation = "h"
let g:VimuxHeight = "50"

map <Leader>r :VimuxPromptCommand<CR>
map <Leader>r[ :VimuxInspectRunner<CR>
map <Leader>rz :VimuxZoomRunner<CR>
map <Leader>rc :VimuxClearRunnerHistory<CR>
map <Leader>rl :VimuxRunLastCommand<CR>
