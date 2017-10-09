" Welcome to…
"
" I N I T . V I M
"
" “ 𝘞𝘩𝘦𝘳𝘦 𝘴𝘱𝘢𝘳𝘦 𝘵𝘪𝘮𝘦 𝘨𝘰𝘦𝘴 𝘵𝘰 𝘥𝘪𝘦.™ ”

"""""""""""""""""""""
" Environment setup "
"""""""""""""""""""""
" First, make sure we know where to store our stuff.
if !exists('$XDG_CONFIG_HOME')
    let $XDG_CONFIG_HOME=glob('$HOME').'/.config/'
    echo '$XDG_CONFIG_HOME is unset, defaulting to '.glob('$XDG_CONFIG_HOME')
endif

if !exists('$XDG_DATA_HOME')
    let $XDG_DATA_HOME=glob('$HOME').'/.local/share/'
    echo '$XDG_DATA_HOME is unset, defaulting to '.glob('$XDG_DATA_HOME')
endif

" Make sure said stuff actually ends up somewhere.
silent !mkdir -p "$XDG_CONFIG_HOME"
silent !mkdir -p "$XDG_DATA_HOME"

set runtimepath=$XDG_CONFIG_HOME/nvim,$XDG_DATA_HOME/nvim,$VIMRUNTIME,$XDG_CONFIG_HOME/nvim/after

"""""""""""""""""""""""
" Basic configuration "
"""""""""""""""""""""""
" Silence the intro message.
set shortmess+=I

" Let me open new files without saving first.
set hidden

" Much easier to reach.
let mapleader=','

" Detect filetypes.
filetype on
filetype plugin on
filetype indent on

" Make everything pretty.
colorscheme later-this-evening
syntax on

set formatoptions+=rwn1
set formatoptions-=tc

set number
set mouse=n " Mouse is for scrolling in normal mode only.
set scrolloff=999 " Enable side-scroller editing.
set statusline=%t
set colorcolumn=80
set guicursor=
set noshowcmd

" Wrapping stuff
set showbreak=↪\ 
set linebreak
set sidescroll=5
set listchars+=precedes:<
set listchars+=extends:>

set breakindent
set breakindentopt=shift:0

set virtualedit=block

" Set up our tab handling.
set autoindent
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set backspace=2

" Improve searching.
set ignorecase
set smartcase

" Completion
set completeopt=menu,longest

" Global and project tags.
set tags=$XDG_CACHE_HOME/tags,./tags;/,tags;/

" Sync the unnamed register with the system clipboard.
set clipboard^=unnamed

" Make the sign gutter always visible to avoid it jumping around.
augroup dummysign | au!
    autocmd BufEnter * sign define dummy
    autocmd BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
augroup end

" Makes panes keep relative widths.
autocmd VimResized * wincmd =

" Force syntax highlighting to always analyze the entire file for Python.
autocmd BufEnter *.py :syntax sync fromstart

" Update the editor state more frequently when the cursor isn't moving around,
" this makes Tagbar jump to the current tag faster.
set updatetime=1000

""""""""""""
" Commands "
""""""""""""
" Open a terminal in a new vertical split
function! Vterm()
  execute "vertical botright split"
  execute "terminal"
endfunction

command! Vterm call Vterm()

" This is good for Makefiles, but that's about it
command! RealTabs %s-^\(    \)\+-	

" Truncate and quit
command! Tq %d | wq

" Git blame the current line
command! Blame exec '!git blame -L'.line('.').','.line('.').' -- % | perl -pe "s/.* \((.*) (\d{4}\-\d{2}\-\d{2}) .*/\1 \2/"'

function! <SID>SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

function! TmuxZoom()
    execute "!tmux resize-pane -Z"
endfunction

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
nnoremap <Leader>tz :silent call TmuxZoom()<CR>
nnoremap <Leader>ds :call <SID>SynStack()<CR>

" Black-hole characters deleted with x
noremap x "_x

" Fix navigation over line wraps (from http://statico.github.com/vim.html)
nmap j gj
nmap k gk

" Always center lines when jumping to line number (thanks to https://twitter.com/mattboehm/status/316602303312429056)
" (Off for the moment since I have scrolloff set.)
"nnoremap gg ggz.

" Good navigation in command mode
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-b> <S-Left>
cnoremap <C-f> <S-Right>

" Terminal
tnoremap <Esc> <C-\><C-n>

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

" Fix the completion popup:
" Insert a newline on enter even when it's open…
inoremap <expr><CR> pumvisible() ? "\<C-y>\<CR>" : "\<CR>"
" …and use Tab for selection.
inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

"""""""""""""""""
" Abbreviations "
"""""""""""""""""
cabbr <expr> %% expand('%:p:h')
cabbr <expr> snip/ expand('r $XDG_DATA_HOME/nvim/snippets')

""""""""""""""""
" vim Classic™ "
""""""""""""""""
if !has('nvim')
	set directory=$XDG_DATA_HOME/nvim/swap//
	set backupdir=.,$XDG_DATA_HOME/nvim/backup
	set viminfo+=n$XDG_DATA_HOME/nvim/shada/viminfo

	set nocompatible
	set wildmenu
	set incsearch
	set hlsearch
    set linebreak

    " neovim understands bracketed pastes, so this is only needed here.
	nnoremap <Leader>tp :set paste! paste?<CR>

    " neovim will automatically create the swap directory, but vim will not.
    silent !mkdir -p "$XDG_DATA_HOME/nvim/swap"
endif

""""""""""""""
" virtualenv "
""""""""""""""
" If we're working in a pipenv, we need to add the virtualenv's site-packages
" to a bunch of python plugins. Store it for easy access.
let g:pipenv_site_packages_path = system('pipenv --venv &>/dev/null && echo -n "$(pipenv --venv)"/lib/python*/site-packages/')

"""""""""""
" Plugins "
"""""""""""
runtime plugins.vim

