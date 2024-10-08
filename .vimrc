"" Dependencies https://github.com/powerline/fonts
set nocompatible
filetype off

call plug#begin('~/.vim/bundle')

Plug 'digitaltoad/vim-pug'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'easymotion/vim-easymotion'
Plug 'editorconfig/editorconfig-vim'
Plug 'godlygeek/tabular'
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'pangloss/vim-javascript'
Plug 'scrooloose/nerdtree'
Plug 'tmhedberg/matchit'
"Plug 'tpope/vim-haml'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
"Plug 'tpope/vim-liquid'
"Plug 'tpope/vim-commentary'
Plug 'Yggdroot/indentLine'
Plug 'mileszs/ack.vim'
Plug 'yssl/QFEnter'
"Plug 'airblade/vim-gitgutter'
"Plug 'moll/vim-bbye'
Plug 'posva/vim-vue'
Plug 'wakatime/vim-wakatime'

" Typescript
"Plug 'leafgarland/typescript-vim'

" Copilot
Plug 'github/copilot.vim', { 'branch': 'release' }

call plug#end()

" basic
filetype plugin indent on
syntax on
set ttyfast
set lazyredraw

" change leader key
let mapleader="m"

" theme and color
set t_Co=256
set background=dark
colorscheme koehler

" numbering and rulers
set relativenumber
set number
set cursorline
set colorcolumn=81
highlight CursorColumn ctermbg=8
highlight ColorColumn ctermbg=8

" fix normal keys, and lock mouse
set backspace=indent,eol,start
set mouse=

" Disable visual sound
set novb

" new window or pane should be appended to bottom right
set splitbelow
set splitright

" handy mapping
set pastetoggle=<leader>p
nnoremap ; :
vnoremap ; :
nnoremap , /,<CR>:noh<cr>
vnoremap , /,<CR>:noh<cr>
noremap j gj
noremap k gk
noremap <BS> <NOP>
set backspace=0
nnoremap <C-j> gj
nnoremap <C-k> gk
nnoremap <C-^> g^
nnoremap <C-$> g$
nnoremap <C-0> g0
nnoremap <BAR> :set cursorcolumn!<BAR>set cursorline!<CR>
noremap / /\v
vnoremap # y/<C-R>"<CR>"
" Full tab edit
nmap t% :tabedit %<CR>
nmap td :tabclose<CR>

" Alt key to esc
imap <M-[> <Esc>
imap jj <Esc>

" check one time after 4s of inactivity in normal mode
set autoread
au CursorHold * checktime

if bufwinnr(1)
  " pane resize vertically = -
  " and horizontally + _
  map = 5<c-w>>
  map - 5<c-w><
  map + 5<c-w>+
  map _ 5<c-w>-
endif

" tab stops
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set modeline
set modelines=5

" searching
set showcmd
set hlsearch
set modifiable
set smartcase
set ignorecase
map <space> :noh<cr>

" show hidden chars
set listchars=tab:>-,trail:.
set list

" text format
set wrap
set showmatch

" disable swap files
set nobackup
set nowritebackup
set noswapfile

" large file handle
let g:LargeFile = 10 * 1024 * 1024
augroup LargeFile
  autocmd BufReadPre * let f=getfsize(expand("<afile>")) | if f > g:LargeFile || f == -2 | call LargeFile() | endif
augroup END
function! LargeFile()
  set eventignore+=FileType " disable filetype related features
  noswapfile
  setlocal bufhidden=unload " save memory when other file is viewed
  setlocal buftype=nowrite
  setlocal undolevels=1
  autocmd VimEnter *  echo "Entering large-file-mode as file is larger than " . (g:LargeFile / 1024 / 1024) . "MB"
endfunction

" sudo switch with W
command! W exec 'w !sudo tee % > /dev/null' | e!

" neovim
if has('nvim')
  " terminal
  tnoremap <Esc> <C-\><C-n>

  tnoremap <C-w>h <C-\><C-n><C-w>h
  tnoremap <C-w>j <C-\><C-n><C-w>j
  tnoremap <C-w>k <C-\><C-n><C-w>k
  tnoremap <C-w>l <C-\><C-n><C-w>l

  tnoremap <C-w>H <C-\><C-n><C-w>H
  tnoremap <C-w>J <C-\><C-n><C-w>J
  tnoremap <C-w>K <C-\><C-n><C-w>K
  tnoremap <C-w>L <C-\><C-n><C-w>L

  autocmd BufWinEnter,WinEnter term://* startinsert
  autocmd BufLeave term://* stopinsert
endif


"--------------------------------- PLUGIN -------------------------------------"

" Ctrlp
" @see https://github.com/ctrlpvim/ctrlp.vim
"let g:ctrlp_map = '<c-q>'
let g:ctrlp_max_files = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_show_hidden = 1
set wildignore+=*/vendors/**
set wildignore+=*/vendor/**
set wildignore+=*/node_modules/**
set wildignore+=*/bower_components/**
set wildignore+=*/.git/**
set wildignore+=*/.svn/**
set wildignore+=*/storage/**
set wildignore+=*/semantic/**
set wildignore+=*/coverage/**

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Wild settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem
set wildignore+=*.psd,*.png,*.jpg,*.gif,*.jpeg
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*,*/kirki/*,*/dist/*,*/node_modules/*,*/bower_components/*,*/coverage/*
set wildignore+=*.swp,*~,._*
set wildignore+=*.min.js
set wildignore+=*.pot,*.po,*.mo
set wildignore+=*.eot,*.eol,*.ttf,*.otf,*.afm,*.ffil,*.fon,*.pfm,*.pfb,*.woff,*.svg,*.std,*.pro,*.xsf


" Nerdtree
" @see https://github.com/scrooloose/nerdtree
"   Ctrl + O to toggle
"   and show-on folder open
"
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
map <C-o> :NERDTreeToggle<CR>
" Binding to like CtrlP
let g:NERDTreeMapOpenSplit = '<C-x>'
let g:NERDTreeMapOpenVSplit = '<C-v>'
let NERDTreeShowLineNumbers=1
autocmd FileType nerdtree setlocal relativenumber

let NERDTreeIgnore = ['\.pyc$', 'vendors', 'bower_components', 'node_modules']
" hide on startup
function! StartUp()
  if 0 == argc()
    NERDTreeClose
  end
endfunction

autocmd VimEnter * call StartUp()


"--------------------------------- EXTRA -------------------------------------"


" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g "" --ignore={\*.psd,\*.jpg,\*.png,\*.jpeg,\*.gif,\*.eot,\*.eol,\*.ttf,\*.otf,\*.afm,\*.ffil,\*.fon,\*.pfm,\*.pfb,\*.woff,\*.svg,\*.std,\*.pro,\*.xsf,\*.zip,\*.tar.gz,\*.tar.bz2,\*.rar,\*.tar.xz} --ignore=package-lock.json --ignore=yarn.lock --ignore-dir=includes/cmb2 --ignore-dir=inc/cmb2 --ignore-dir=semantic --ignore-dir=node_modules --ignore-dir=bower_components --ignore-dir=dist --ignore-dir=vendor'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
  let g:ackprg = 'ag --nogroup --nocolor --column --ignore=package-lock.json --ignore=yarn.lock --ignore-dir=includes/cmb2 --ignore-dir=inc/cmb2 --ignore-dir=semantic --ignore-dir=node_modules --ignore-dir=bower_components --ignore-dir=dist --ignore-dir=vendor'
endif

cnoreabbrev Ack Ack!
noremap <C-s> :Ack! <cword><cr>
noremap <C-a> :Ack!<space>

" Disable Ack mapping to use QFEnter
let g:ack_apply_qmappings = 0
let g:ack_apply_lmappings = 0

" QF Enter
" like CtrlP
let g:qfenter_keymap = {}
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.hopen = ['<C-CR>', '<C-s>', '<C-x>']
let g:qfenter_keymap.topen = ['<C-t>']

" Tabular
noremap <C-t> :Tab /

" Vim indent
" autocmd BufRead,BufNewFile * IndentGuidesEnable
" let g:indent_guides_start_level= 2
" let g:indent_guides_guide_size = 1
" hi IndentGuidesEven ctermbg=darkgrey

" indent line
" @link https://github.com/Yggdroot/indentLine
let g:indentLine_color_term = 239
let g:indentLine_char = '┆'
" let g:indentLine_faster = 1


" Light line
" @see https://github.com/itchyny/lightline.vim
set laststatus=2
let g:lightline = {
\ 'colorscheme': 'PaperColor_dark',
\ 'active': {
\   'left': [
\     [ 'mode', 'paste' ],
\     [ 'readonly', 'filename', 'modified' ]
\   ],
\   'right': [
\     [ 'lineinfo' ],
\     [ 'percent' ],
\     [ 'fileformat', 'fileencoding', 'filetype' ]
\   ]
\ },
\ 'component_function': {
\   'readonly': 'LightlineReadonly',
\   'modified': 'LightlineModified',
\   'filename': 'LightlineFilename'
\ },
\ 'separator': { 'left': '', 'right': ''  },
\ 'subseparator': { 'left': '\ue0b1', 'right': '\ue0b3'  }
\ }

function! LightlineModified()
  if &filetype == "help"
    return ""
  elseif &modified
    return "+"
  elseif &modifiable
    return ""
  else
    return ""
  endif
endfunction

function! LightlineReadonly()
  if &filetype == "help"
    return ""
  elseif &readonly
    return ""
  else
    return ""
  endif
endfunction

function! LightlineFilename()
  return ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
  \ ('' != expand('%:t') ? expand('%:t') : '[Unnamed]') .
  \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction

" Jade
autocmd BufRead,BufNewFile *.jade setlocal ft=pug
autocmd BufRead,BufNewFile *.liquid setlocal ft=html

" Easymotion
map m <Plug>(easymotion-prefix)
map ml <Plug>(easymotion-lineforward)
map mj <Plug>(easymotion-j)
map mk <Plug>(easymotion-k)
map mh <Plug>(easymotion-linebackward)
let g:EasyMotion_startofline = 0 " keep cursor column when JK motion

" Gitgutter
set signcolumn=yes
let g:gitgutter_max_signs = 500
let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0

" Vim javascript
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1

" Scss syntax
au BufRead,BufNewFile *.scss set filetype=css
au BufRead,BufNewFile *.sass set filetype=css
augroup VimCSS3Syntax
  autocmd!

  autocmd FileType css setlocal iskeyword+=-
augroup END


" New 27-12-2017
:nnoremap <Leader>q :Bdelete<CR>

" JAVASCRIPT AUTOCOMPLTE

" Typescript
"nmap <C-c> :TsuGeterr<CR>


" Load local vimrc, if any
silent! source ~/.vimrc.local
