""""""""""""
" vim-plug "
""""""""""""
" The first time we run vim, we need to install vim-plug and all of the
" plugins. To do this, we bootstrap vim-plug manually using curl, and then set
" up and autocmd which runs PlugInstall and re-sources this file as soon as
" vim finishes starting. To prevent plugin configuration from executing before
" the plugins exist, s:plugins_ready is set to zero the first time through.

let s:plugins_ready = 0
let g:plug_window = 'topleft new'

let s:vimplug = stdpath('data') . '/site/autoload/plug.vim'
if empty(glob(s:vimplug))
    echo "Installing vim-plug…"
    exec '!curl -fLo ' . s:vimplug . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * ++once PlugInstall | q | runtime plugins.vim
else
    let s:plugins_ready = 1
endif

call plug#begin(stdpath('data') . '/plugged')

    Plug 'junegunn/fzf' | Plug 'junegunn/fzf.vim'
    Plug 'mhinz/vim-startify'
    Plug 'majutsushi/tagbar'
    Plug 'tpope/vim-sleuth'
    Plug 'editorconfig/editorconfig-vim'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'wesQ3/vim-windowswap'
    Plug 'kana/vim-scratch'
    Plug 'PeterRincker/vim-argumentative'
    Plug 'tpope/vim-surround'
    Plug 'ntpeters/vim-better-whitespace'
    Plug 'chaoren/vim-wordmotion'

    Plug 'k4nar/braceless.vim', {'branch': 'async-syntax'}
    Plug 'Rykka/riv.vim'
    Plug 'Rykka/InstantRst'
    Plug 'keith/tmux.vim'
    Plug 'othree/html5.vim'
    Plug 'ap/vim-css-color'
    Plug 'dzeban/vim-log-syntax'
    Plug 'nathangrigg/vim-beancount'
    Plug 'jvirtanen/vim-hcl'
    Plug 'chr4/nginx.vim'

call plug#end()

if !s:plugins_ready
    finish
end

""""""""""""
" Startify "
""""""""""""
let g:startify_change_to_vcs_root = 1
let g:startify_update_oldfiles = 1
let g:startify_fortune_use_unicode = 1
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

"""""""
" riv "
"""""""
let g:riv_disable_folding = 1

""""""""""""""
" InstantRst "
""""""""""""""
let g:instant_rst_localhost_only = 1

""""""""""""
" coc.nvim "
""""""""""""
let g:coc_data_home = stdpath('data') . '/coc'
let g:coc_global_extensions = ["coc-json", "coc-diagnostic", "coc-jedi"]

" Weird things happen if this isn't low, like files being compiled with munged content.
set updatetime=300

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <silent><expr> <S-TAB>
      \ pumvisible() ? "\<C-p>" :
      \ <SID>check_back_space() ? "\<S-TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

set statusline+=%=%{coc#status()}%{get(b:,'coc_current_function','')}

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>ca <Plug>(coc-codeaction-selected)
nmap <leader>ca <Plug>(coc-codeaction-selected)

nmap <leader>cf <Plug>(coc-fix-current)
nmap <leader>cr <Plug>(coc-rename)
nnoremap <silent> <leader>cd :<C-u>CocList diagnostics<cr>
nnoremap <silent> <leader>ce :<C-u>CocList extensions<cr>
nnoremap <silent> <leader>cc :<C-u>CocList commands<cr>
nnoremap <silent> <leader>co :<C-u>CocList outline<cr>
nnoremap <silent> <leader>cs :<C-u>CocList -I symbols<cr>
nnoremap <silent> <leader>cj :<C-u>CocNext<cr>
nnoremap <silent> <leader>ck :<C-u>CocPrev<cr>


"""""""""""
" Cleanup "
"""""""""""
syntax on " Reenable syntax highlighting in case we loaded a plugin that changes it.
