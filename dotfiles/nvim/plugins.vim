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
let g:coc_global_extensions = ["coc-json", "coc-python"]

set updatetime=300

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

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

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
set statusline+=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>


"""""""""""
" Cleanup "
"""""""""""
syntax on " Reenable syntax highlighting in case we loaded a plugin that changes it.
