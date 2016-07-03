""""""""""""
" vim-plug "
""""""""""""
let g:plugins_ready = 0
let g:plug_window = 'topleft new' " Make sure the window shows up in a good spot the first run.

if empty(glob('$XDG_DATA_HOME/nvim/autoload/plug.vim'))
    echo "Installing vim-plug…"
    silent exec '!curl -fLo '.expand('$XDG_DATA_HOME/nvim/autoload/plug.vim').' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    echo "Installed. PlugInstall will run automatically, then restart nvim."
    autocmd VimEnter * PlugInstall
    " TODO: Re-source this file instead of forcing a restart. Needs vim-plug#104.
else
    let g:plugins_ready = 1
endif

" This must use expand(), glob returns empty string if the directory doesn't exist.
" We know the variable is non-empty by now, so no need to worry about that.
call plug#begin(expand('$XDG_DATA_HOME/nvim/plugged'))

    Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle', 'tag': '*' }
    Plug 'embear/vim-localvimrc', { 'tag': '*' }
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'Raimondi/delimitMate'
    Plug 'Shougo/unite.vim', { 'tag': '*' }
    Plug 'mhinz/vim-startify'
    Plug 'neomake/neomake'
    Plug 'ap/vim-css-color'
    Plug 'PeterRincker/vim-argumentative'
    Plug 'tweekmonster/braceless.vim', { 'tag': '*' }
    Plug 'guns/xterm-color-table.vim'
    Plug 'tpope/vim-surround'
    Plug 'wesQ3/vim-windowswap'

    if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'tag': '*' }
    endif

    " Syntax
    Plug 'rust-lang/rust.vim'
    Plug 'keith/tmux.vim'
    Plug 'othree/html5.vim'
    Plug 'vim-scripts/groovy.vim'

call plug#end()

if g:plugins_ready

"""""""""
" Unite "
"""""""""
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])

autocmd FileType unite call s:unite_settings()

function! s:unite_settings()
    imap <buffer> <ESC> <Plug>(unite_exit)
endfunction

nnoremap <silent> <Leader>. :Unite -no-split -start-insert -auto-preview file_rec buffer:-<CR>
nnoremap <silent> <Leader>, :Unite -no-split -start-insert -auto-preview buffer:-<CR>

""""""""""""
" deoplete "
""""""""""""
if exists("*DeopleteEnable")
    DeopleteEnable
endif

inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

""""""""""""""
" localvimrc "
""""""""""""""
let g:localvimrc_sandbox = 0
let g:localvimrc_ask = 0

""""""""""""
" NERDTree "
""""""""""""
let g:NERDTreeWinSize = 40

"""""""""""
" neomake "
"""""""""""
let g:neomake_python_enabled_makers = [ 'pylint' ]
let g:neomake_rust_enabled_makers = [ 'rustc' ]

augroup neomake_onsave | au!
    autocmd! BufWritePost * Neomake
augroup end

""""""""""""
" Startify "
""""""""""""
let g:startify_change_to_vcs_root = 1

"""""""""""""
" Braceless "
"""""""""""""
let g:braceless_line_continuation = 0
autocmd FileType python BracelessEnable +indent

"""""""""""
" Cleanup "
"""""""""""
syntax on " Reenable syntax highlighting in case we loaded a plugin that changes it.

endif
unlet g:plugins_ready

