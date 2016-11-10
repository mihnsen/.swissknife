" Dependencies https://github.com/powerline/fonts
set nocompatible
filetype off

call plug#begin('~/.vim/bundle')

Plug 'ap/vim-css-color'
Plug 'digitaltoad/vim-pug'
"Plug 'easymotion/vim-easymotion'
Plug 'editorconfig/editorconfig-vim'
Plug 'groenewege/vim-less'
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'ctrlpvim/ctrlp.vim'
"Plug 'mattn/emmet-vim'
"Plug 'pangloss/vim-javascript'
Plug 'godlygeek/tabular'
Plug 'scrooloose/nerdtree'
Plug 'tmhedberg/matchit'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-haml'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
"Plug 'Yggdroot/indentLine'
Plug 'mileszs/ack.vim'
Plug 'scrooloose/nerdcommenter'
"Plug 'janko-m/vim-test'
Plug 'yssl/QFEnter'
Plug 'ervandew/supertab'
Plug 'airblade/vim-gitgutter'

"Plug 'Valloric/YouCompleteMe', { 'do': 'python2.7 install.py --tern-completer' }

function! YCMInstall(info)
  if a:info.status == 'installed'
    !./install.sh --tern-completer
  endif
endfunction
Plug 'Valloric/YouCompleteMe', { 'on': [], 'do': function('YCMInstall') }
let g:ycm_confirm_extra_conf    = 0
let g:ycm_extra_conf_vim_data   = ['&filetype']
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_enable_diagnostic_signs = 0
augroup load_ycm
  autocmd!
  autocmd! InsertEnter *
        \ call plug#load('YouCompleteMe')     |
        \ if exists('g:loaded_youcompleteme') |
        \   call youcompleteme#Enable()       |
        \ endif                               |
        \ autocmd! load_ycm
augroup END

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
"Plug 'kbarrette/mediummode'

call plug#end()

" basic
filetype plugin indent on
syntax on
set ttyfast
set lazyredraw

" change leader key
let mapleader=","

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
" highlight Visual ctermbg=255 ctermfg=16

" fix normal keys, and lock mouse
set backspace=indent,eol,start
set mouse=

" new window or pane should be appended to bottom right
set splitbelow
set splitright

" handy mapping
set pastetoggle=<leader>p
nnoremap ; :
vnoremap ; :
"noremap h <NOP>
"noremap j <NOP>
"noremap k <NOP>
"noremap l <NOP>
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

" sudo switch with w!!
cmap w!! w !sudo tee % >/dev/null


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
" Exchange
" @see https://github.com/tommcdo/vim-exchange
let g:exchange_no_mappings=1
nmap cx <Plug>(Exchange)
vmap X <Plug>(Exchange)
nmap cxc <Plug>(ExchangeClear)
nmap cxx <Plug>(ExchangeLine)


" Ctrlp
" @see https://github.com/ctrlpvim/ctrlp.vim
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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Wild settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem
set wildignore+=*.psd,*.png,*.jpg,*.gif,*.jpeg
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*
set wildignore+=*.swp,*~,._*
set wildignore+=*.min.js
set wildignore+=*.pot,*.po,*.mo
set wildignore+=*.eot,*.eol,*.ttf,*.otf,*.afm,*.ffil,*.fon,*.pfm,*.pfb,*.woff,*.svg,*.std,*.pro,*.xsf
set wildignore+=*/kirki/*


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

let NERDTreeIgnore = ['\.pyc$', '\.png$', '\.jpg$', 'vendor', 'vendors', 'bower_components', 'node_modules']
" hide on startup
function! StartUp()
  if 0 == argc()
    NERDTreeClose
  end
endfunction

autocmd VimEnter * call StartUp()


"--------------------------------- EXTRA -------------------------------------"


" Ultisnips
" let g:UltiSnipsExpandTrigger="<c-k>"
" let g:UltiSnipsJumpForwardTrigger="<c-b>"
" let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" The Silver Searcher
if executable('ag')
 " Use ag over grep
 set grepprg=ag\ --nogroup\ --nocolor

 " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
 let g:ctrlp_user_command = 'ag %s -l --nocolor -g "" --ignore={*.psd,*.jpg,*.png,*.jpeg,*.gif,*.eot,*.eol,*.ttf,*.otf,*.afm,*.ffil,*.fon,*.pfm,*.pfb,*.woff,*.svg,*.std,*.pro,*.xsf,*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz}'

 " ag is fast enough that CtrlP doesn't need to cache
 let g:ctrlp_use_caching = 0
endif
let g:ackprg = 'ag --nogroup --nocolor --column'
cnoreabbrev Ack Ack!
noremap <C-s> :Ack! <cword><cr>
noremap <C-a> :Ack!<space>

" Disable Ack mapping to use QFEnter
let g:ack_apply_qmappings = 0
let g:ack_apply_lmappings = 0

" QF Enter
" like CtrlP
let g:qfenter_vopen_map = ['<C-v>']
let g:qfenter_hopen_map = ['<C-CR>', '<C-s>', '<C-x>']
let g:qfenter_topen_map = ['<C-t>']

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

" Easymotion
map m <Plug>(easymotion-prefix)
map ml <Plug>(easymotion-lineforward)
map mj <Plug>(easymotion-j)
map mk <Plug>(easymotion-k)
map mh <Plug>(easymotion-linebackward)
let g:EasyMotion_startofline = 0 " keep cursor column when JK motion


" make YCM compatible with UltiSnips (using supertab)
" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger           = "<C-e>"
let g:UltiSnipsJumpForwardTrigger      = "<C-j>"
let g:UltiSnipsJumpBackwardTrigger     = "<C-k>"

let g:ycm_key_list_select_completion   = ['<C-n>', '<C-j>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<C-k>', '<Up>']

let g:SuperTabDefaultCompletionType    = '<C-n>'
let g:SuperTabCrMapping                = 0


" Additional YouCompleteMe config.
let g:ycm_dont_warn_on_startup = 0
let g:ycm_complete_in_comments = 1
let g:ycm_complete_in_strings = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_seed_identifiers_with_syntax = 1
" Disable unhelpful semantic completions.
let g:ycm_filetype_specific_completion_to_disable = {
      \   'c': 1,
      \   'gitcommit': 1,
      \   'haskell': 1,
      \   'ruby': 1
      \ }
" Same as default, but with "markdown" and "text" removed.
let g:ycm_filetype_blacklist = {
      \   'notes': 1,
      \   'unite': 1,
      \   'tagbar': 1,
      \   'pandoc': 1,
      \   'qf': 1,
      \   'vimwiki': 1,
      \   'infolog': 1,
      \   'mail': 1
      \ }

" Additional UltiSnips config.
let g:UltiSnipsListSnippets = "<C-l>"
let g:UltiSnipsSnippetsDir  = '~/.vim/bundle/vim-snippets/UltiSnips'
let g:UltiSnipsEditSplit    = 'vertical'
nnoremap <leader>ue :UltiSnipsEdit<space>

autocmd FileType javascript UltiSnipsAddFiletypes javascript-jasmine
autocmd FileType javascript UltiSnipsAddFiletypes javascript-angular
autocmd FileType javascript UltiSnipsAddFiletypes javascript-jsdoc
autocmd FileType javascript UltiSnipsAddFiletypes javascript-ember
autocmd FileType javascript UltiSnipsAddFiletypes javascript-node
autocmd FileType javascript UltiSnipsAddFiletypes javascript-mocha
autocmd FileType php UltiSnipsAddFiletypes html
autocmd FileType php UltiSnipsAddFiletypes html_minimal

" UltiSnips completion function that tries to expand a snippet.
" @see https://github.com/Valloric/YouCompleteMe/issues/420
    function! g:JInYCM()
        if pumvisible()
            return "\<C-n>"
        else
            return "\<c-j>"
    endfunction
    
    function! g:KInYCM()
        if pumvisible()
            return "\<C-p>"
        else
            return "\<c-k>"
    endfunction
    
    inoremap <c-j> <c-r>=g:JInYCM()<cr>
    au BufEnter,BufRead * exec "inoremap <silent> " . g:UltiSnipsJumpBackwordTrigger . " <C-R>=g:KInYCM()<cr>"
    let g:UltiSnipsJumpBackwordTrigger = "<c-k>"

" Gitgutter
let g:gitgutter_sign_column_always = 1


" Load local vimrc, if any
silent! source ~/.vimrc.local'tpope/�
