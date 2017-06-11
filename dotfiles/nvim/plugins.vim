""""""""""""
" vim-plug "
""""""""""""
" The first time we run vim, we need to install vim-plug and all of the
" plugins. To do this, we bootstrap vim-plug manually using curl, and then set
" up and autocmd which runs PlugInstall and re-sources this file as soon as
" vim finishes starting. To prevent plugin configuration from executing before
" the plugins exist, s:plugins_ready is set to zero the first time through.

let s:plugins_ready = 0
let g:plug_window = 'topleft new' " Make sure the window shows up in a good spot the first run.

if empty(glob('$XDG_DATA_HOME/nvim/autoload/plug.vim'))
    echo "Installing vim-plug…"
    silent exec '!curl -fLo '.expand('$XDG_DATA_HOME/nvim/autoload/plug.vim').' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall | runtime plugins.vim
else
    let s:plugins_ready = 1
endif

" This must use expand(), glob returns empty string if the directory doesn't exist.
" We know the variable is non-empty by now, so no need to worry about that.
call plug#begin(expand('$XDG_DATA_HOME/nvim/plugged'))

    " Core environment
    Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'mhinz/vim-startify'
    Plug 'majutsushi/tagbar'
    Plug 'neomake/neomake'

    " Completion
    if has('nvim')
    Plug 'Shougo/deoplete.nvim', {'tag': '*', 'do': ':UpdateRemotePlugins'}
    Plug 'Shougo/neoinclude.vim'
    Plug 'zchee/deoplete-jedi'
    endif

    " Text objects
    Plug 'PeterRincker/vim-argumentative'
    Plug 'Raimondi/delimitMate'
    Plug 'tpope/vim-surround'
    Plug 'ntpeters/vim-better-whitespace'
    Plug 'easymotion/vim-easymotion', {'tag': '*'}
    Plug 'chaoren/vim-wordmotion'
    Plug 'junegunn/vim-easy-align'

    " Layout + views
    Plug 'wesQ3/vim-windowswap'
    Plug 'kana/vim-scratch'
    Plug 'junegunn/limelight.vim'
    Plug 'junegunn/goyo.vim'

    " Language-specific
    Plug 'tweekmonster/braceless.vim', {'for': 'python', 'tag': '*'}
    Plug 'racer-rust/vim-racer',       {'for': 'rust'}
    Plug 'Rykka/riv.vim',              {'for': 'rst'}
    Plug 'Rykka/InstantRst',           {'for': 'rst'}
    Plug 'dhruvasagar/vim-table-mode', {'for': ['rst', 'markdown']}
    Plug 'avakhov/vim-yaml',           {'for': 'yaml'}

    " Syntax highlighting
    Plug 'rust-lang/rust.vim',    {'for': 'rust'}
    Plug 'keith/tmux.vim',        {'for': 'tmux'}
    Plug 'othree/html5.vim',      {'for': 'html'}
    Plug 'ap/vim-css-color',      {'for': 'css'}
    Plug 'dzeban/vim-log-syntax', {'for': 'log'}

call plug#end()

if s:plugins_ready

""""""""""""
" deoplete "
""""""""""""
let g:deoplete#enable_at_startup = 1
let g:deoplete#buffer#require_same_filetype = 0 " If it's open, it's important.
let g:deoplete#max_menu_width = 80
let g:deoplete#sources#jedi#extra_path = [g:pipenv_site_packages_path]

inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

"""""""""""
" neomake "
"""""""""""
let g:neomake_python_enabled_makers = ['pylint']
let g:neomake_python_pylint_args = [
    \ "--init-hook", "import sys; sys.path.append('".g:pipenv_site_packages_path."')"] +
    \ neomake#makers#ft#python#pylint()['args']

let g:neomake_rust_enabled_makers = ['cargo']

augroup neomake_onsave | au!
    autocmd! BufWritePost * Neomake
    autocmd BufWritePost *.rs Neomake cargo
augroup end

""""""""""""
" Startify "
""""""""""""
let g:startify_change_to_vcs_root = 1
let g:startify_update_oldfiles = 1
let g:startify_list_order = [['   Recent in project'], 'dir',
                           \ ['   Recent globally'], 'files', ]

let s:moose = ['   \',
             \ '    \  \_\_    _/_/',
             \ '     \     \__/',
             \ '           (oo)\_______',
             \ '           (__)\       )\/\',
             \ '               ||------|',
             \ '               ||     ||']
let g:startify_custom_header = map(startify#fortune#boxed() + s:moose, '"   ". v:val')

let g:startify_custom_footer = map(split(system('figlet -f lean neovim'), '\n'), '"   ". v:val')

autocmd User Startified ToggleWhitespace " figlet likes to leave space behind.

"""""""""""""
" Braceless "
"""""""""""""
let g:braceless_line_continuation = 0
autocmd FileType python BracelessEnable +indent

"""""""""""""""
" vim-scratch "
"""""""""""""""
let g:scratch_show_command = 'hide buffer'
nmap <Leader>sc :ScratchOpen<CR>

""""""""""""""""""
" vim-windowswap "
""""""""""""""""""
let g:windowswap_map_keys = 0
nnoremap <silent> <Leader>sw :call WindowSwap#EasyWindowSwap()<CR>

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

set nohlsearch " easymotion handles this

""""""""""
" Tagbar "
""""""""""
let g:tagbar_left = 1
let g:tagbar_sort = 0
let g:tagbar_show_visibility = 0
let g:tagbar_singleclick = 1
let g:tagbar_iconchars = ['▸', '▾']
let g:tagbar_width = 30
let g:tagbar_zoomwidth = 0

" Add the current tag to the statusline as well.
" TODO: This behaves strangely in unfocused splits.
set statusline+=%=%{tagbar#currenttag('\ %s\ ','','f')}

"""""""
" fzf "
"""""""
autocmd! FileType fzf tnoremap <buffer> <Esc> <C-c>
nnoremap <silent> <Leader>. :execute system('git rev-parse --is-inside-work-tree') =~ 'true' ? 'GFiles --cached --others --exclude-standard' : 'Files'<CR>
nnoremap <silent> <Leader>, :Buffers<CR>
nnoremap <silent> <Leader>/ :History/<CR>
nnoremap <silent> <Leader><Space> :Lines<CR>

let g:fzf_layout = { 'window': 'enew' }

""""""""""""""""""
" vim-table-mode "
""""""""""""""""""
let g:table_mode_verbose = 1
let g:table_mode_corner_corner = '+'
let g:table_mode_header_fillchar = '='

autocmd! FileType markdown silent TableModeEnable
autocmd! FileType rst silent TableModeEnable

""""""""
" Goyo "
""""""""
let g:goyo_width = 82

"""""""
" riv "
"""""""
let g:riv_disable_folding = 1

""""""""""""""
" InstantRst "
""""""""""""""
let g:instant_rst_localhost_only = 1

"""""""""""
" Cleanup "
"""""""""""
syntax on " Reenable syntax highlighting in case we loaded a plugin that changes it.

endif
