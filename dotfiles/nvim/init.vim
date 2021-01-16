set hidden

let mapleader=','

filetype on
filetype plugin on
filetype indent on

colorscheme later-this-evening

set formatoptions+=rwn1
set formatoptions-=tc

set number
set mouse=n
set scrolloff=999 " Enable side-scroller editing.
set statusline=%t
set colorcolumn=80
set guicursor=
set noshowcmd
set signcolumn=yes:1

let &showbreak="↪ "
set cpoptions+=n
set linebreak
set sidescroll=5
set listchars+=precedes:<
set listchars+=extends:>
set breakindent

set virtualedit=block

set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

set ignorecase
set smartcase

set clipboard=unnamedplus

" Makes panes keep relative widths.
autocmd VimResized * wincmd =

" Force syntax highlighting to always analyze the entire file for Python.
autocmd BufEnter *.py :syntax sync fromstart

""""""""""""
" Commands "
""""""""""""
" Truncate and quit
command! Tq %d | wq

" Git blame the current line
command! Blame exec '!git blame -L'.line('.').','.line('.').' -- %'

""""""""""""
" Mappings "
""""""""""""
" Source vimrc
nmap <silent> <Leader>sv :so $MYVIMRC<CR> :echo "Sourced" $MYVIMRC<CR>

" Toggles
nnoremap <Leader>th :set hlsearch! hlsearch?<CR>
nnoremap <Leader>tt :set expandtab! expandtab?<CR>
nnoremap <Leader>tw :set wrap! wrap?<CR>
nnoremap <Leader>tr :set relativenumber! relativenumber?<CR>
noremap <Leader>tl :Limelight!!<CR>

" Black-hole characters deleted with x
noremap x "_x

" Fix navigation over line wraps (from http://statico.github.com/vim.html)
nmap j gj
nmap k gk

" Good navigation in command mode
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-b> <S-Left>
cnoremap <C-f> <S-Right>

" Only enable the scroll wheel.
map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>
map <LeftMouse> <Nop>
map <2-LeftMouse> <Nop>
map <C-LeftMouse> <Nop>
map <S-LeftMouse> <Nop>
map <LeftDrag> <Nop>
map <LeftRelease> <Nop>
map <MiddleMouse> <Nop>
map <RightMouse> <Nop>
map <2-RightMouse> <Nop>
map <A-RightMouse> <Nop>
map <S-RightMouse> <Nop>
map <C-RightMouse> <Nop>
map <RightDrag> <Nop>
map <RightRelease> <Nop>

" Make Y act like all the other capital variants.
nnoremap Y y$

"""""""""""""""""
" Abbreviations "
"""""""""""""""""
cabbr <expr> %% expand('%:p:h')

"""""""""""""""
" virtualenvs "
"""""""""""""""
" Use systemlist because it strips off the newline.
let g:neovim_virtualenv = systemlist('cd $XDG_CONFIG_HOME/nvim && venv-locate')[0]
let g:python3_host_prog = g:neovim_virtualenv.'/bin/python3'

let $PATH = fnamemodify(g:python3_host_prog, ':h') . ':' . $PATH

""""""""""""""
" autocommit "
""""""""""""""
augroup AutoCommit | au!
    autocmd VimEnter,DirChanged * let g:commit_on_save = systemlist(
        \ 'git config --local --get --default false nvim.commitonsave')[0]
    autocmd BufWritePost,FileWritePost *
        \ if g:commit_on_save == 'true' && expand('%:h:t') != '.git' |
        \     silent call system('git add -A && git commit -a -m "autocommit '.expand('<afile>').'"') |
        \ fi
augroup end

"""""""""""
" Plugins "
"""""""""""
runtime plugins.vim

