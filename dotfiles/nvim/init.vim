if !has("nvim")
    " Make vim Classic™ behave as similarly as possible.
    " Also provide some bindings for actions which aren't necessary in nvim.

	set directory=$XDG_DATA_HOME/nvim/swap//
	set backupdir=.,$XDG_DATA_HOME/nvim/backup
	set viminfo+=n$XDG_DATA_HOME/nvim/shada/viminfo
	set runtimepath=$XDG_CONFIG_HOME/nvim,$VIMRUNTIME,$XDG_DATA_HOME/nvim/after,$XDG_CONFIG_HOME/nvim/after

	set nocompatible
	set wildmenu
	set incsearch
	set hlsearch
    set linebreak

	nnoremap <Leader>tp :set paste! paste?<CR>
endif

call plug#begin(expand('$MYVIMRC:h/plugged'))

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'rust-lang/rust.vim'
Plug 'embear/vim-localvimrc'
Plug 'christoomey/vim-tmux-navigator'
Plug 'Townk/vim-autoclose'
Plug 'Shougo/unite.vim'
Plug 'keith/tmux.vim'

call plug#end()

" Silence the intro message.
set shortmess+=I

" Let me open new files without saving first.
set hidden

" Much easier to reach.
let mapleader=","

" Detect filetypes.
filetype on
filetype plugin on
filetype indent on

" Make everything pretty.
set formatoptions+=rwn1
set formatoptions-=t
set formatoptions-=c
syntax on
set number

" Wrapping stuff
set breakindent
set breakindentopt=shift:2
set linebreak
set sidescroll=5
set listchars+=precedes:<
set listchars+=extends:>

" Make editing actually usable.
set autoindent
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set backspace=2

" Improve searching.
set ignorecase
set smartcase

" Sync the unnamed register with the system clipboard.
set clipboard^=unnamed

" This is good for Makefiles, but that's about it:
command! RealTabs %s-^\(    \)\+-	

""""" Mappings """""

" Unite
nnoremap <silent> <Leader>. :Unite -no-split -start-insert -auto-preview file_rec buffer<CR>
nnoremap <silent> <Leader>, :Unite -no-split -start-insert -auto-preview buffer<CR>
"nnoremap <silent> <Leader>/ :Unite grep:.<CR> " This won't work until Shougo rewrites Unite for neovim.

" Source vimrc:
nmap <silent> <Leader>sv :so $MYVIMRC<CR> :echo "Sourced" $MYVIMRC<CR>

" Toggles
nnoremap <Leader>th :set hlsearch! hlsearch?<CR>
nnoremap <Leader>tt :set expandtab! expandtab?<CR>
nnoremap <Leader>tw :set wrap! wrap?<CR>
nnoremap <Leader>tr :set relativenumber! relativenumber?<CR>

" Black-hole characters deleted with x
noremap x "_x

" Fix navigation over line wraps: (from http://statico.github.com/vim.html)
nmap j gj
nmap k gk

" Always center lines when jumping to line number (thanks to https://twitter.com/mattboehm/status/316602303312429056):
nnoremap gg ggz.

""""" Plugin config """""

" Unite
call unite#filters#matcher_default#use(['matcher_fuzzy'])

augroup UniteOverrides
    autocmd!
    autocmd FileType unite call s:unite_settings()
augroup end

function! s:unite_settings()
    imap <buffer> <ESC> <Plug>(unite_exit)
endfunction

" localvimrc:
let g:localvimrc_sandbox = 0
let g:localvimrc_ask = 0

" NERDTree:
let g:NERDTreeWinSize = 40

