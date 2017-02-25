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
    Plug 'mhinz/vim-startify'
    Plug 'neomake/neomake'
    Plug 'ap/vim-css-color'
    Plug 'PeterRincker/vim-argumentative'
    Plug 'tweekmonster/braceless.vim', { 'tag': '*' }
    Plug 'guns/xterm-color-table.vim'
    Plug 'tpope/vim-surround'
    Plug 'wesQ3/vim-windowswap'
    Plug 'easymotion/vim-easymotion', { 'tag': '*' }
    Plug 'plasticboy/vim-markdown'
    Plug 'vim-scripts/taglist.vim'
    Plug 'kana/vim-scratch'
    Plug 'ntpeters/vim-better-whitespace'
    Plug 'junegunn/limelight.vim'
    Plug 'junegunn/vim-easy-align'
    Plug 'racer-rust/vim-racer'
    Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'

    if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " TODO: Pin to tag once on_init is in a release (for jedi).
    Plug 'Shougo/neoinclude.vim'
    Plug 'zchee/deoplete-jedi'
    endif

    " Syntax
    Plug 'rust-lang/rust.vim'
    Plug 'keith/tmux.vim'
    Plug 'othree/html5.vim'
    Plug 'vim-scripts/groovy.vim'

call plug#end()

if g:plugins_ready

""""""""""""
" deoplete "
""""""""""""
call deoplete#enable()
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
let g:neomake_rust_enabled_makers = []

augroup neomake_onsave | au!
    autocmd! BufWritePost * Neomake
    autocmd BufWritePost *.rs Neomake! cargo
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

"""""""""""""
" Limelight "
"""""""""""""
let g:limelight_conceal_ctermfg = 'black'

" Default: 0.5
let g:limelight_default_coefficient = 1.0

" Number of preceding/following paragraphs to include (default: 0)
let g:limelight_paragraph_span = 1

" Beginning/end of paragraph
"   When there's no empty line between the paragraphs
"   and each paragraph starts with indentation
let g:limelight_bop = '^\s'
let g:limelight_eop = '\ze\n^\s'

" Highlighting priority (default: 10)
"   Set it to -1 not to overrule hlsearch
let g:limelight_priority = -1

""""""""""""""""
" vim-markdown "
""""""""""""""""
let g:vim_markdown_folding_disabled = 1

""""""""""""""
" easymotion "
""""""""""""""
map  \ <Plug>(easymotion-prefix)

" Replace vim search and highlighting.
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)

let g:EasyMotion_startofline = 0 " keep cursor column when JK motion

"""""""
" fzf "
"""""""
autocmd! FileType fzf tnoremap <buffer> <Esc> <C-c>
nnoremap <silent> <Leader>. :GFiles --cached --others --exclude-standard<CR>
nnoremap <silent> <Leader>, :Buffers<CR>
nnoremap <silent> <Leader>/ :History/<CR>
nnoremap <silent> <Leader><Space> :Lines<CR>

"""""""""""
" Cleanup "
"""""""""""
syntax on " Reenable syntax highlighting in case we loaded a plugin that changes it.

endif
unlet g:plugins_ready

