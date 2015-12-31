call plug#begin('~/.vim/plugged')

Plug 'wincent/command-t'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'rust-lang/rust.vim'
Plug 'embear/vim-localvimrc'
Plug 'christoomey/vim-tmux-navigator'
Plug 'Townk/vim-autoclose'

call plug#end()

" Let me open new files without saving first.
set hidden

" Much easier to reach.
let mapleader=","

" Detect filetypes.
filetype on
filetype plugin on
filetype indent on

" Make everything pretty.
set formatoptions+=rwan1
syntax on
set lbr
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

" Tabline config (hi = hilight):
hi TabLineFill ctermfg=7 ctermbg=7
hi TabLine cterm=bold ctermfg=7
hi TabLineSel cterm=bold
set showtabline=2

""""" Mappings """""

" Command-T
nnoremap <silent> <Leader>. :CommandT<CR>
nnoremap <silent> <Leader>, :CommandTBuffer<CR>

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

" localvimrc:
let g:localvimrc_sandbox = 0
let g:localvimrc_ask = 0

" NERDTree:
let g:NERDTreeWinSize = 40
