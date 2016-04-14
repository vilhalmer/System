" Plugin configuration

" Unite

call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])

autocmd FileType unite call s:unite_settings()

function! s:unite_settings()
    imap <buffer> <ESC> <Plug>(unite_exit)
endfunction

nnoremap <silent> <Leader>. :Unite -no-split -start-insert -auto-preview file_rec buffer<CR>
nnoremap <silent> <Leader>, :Unite -no-split -start-insert -auto-preview buffer<CR>

" deoplete

if exists("*DeopleteEnable")
    DeopleteEnable
endif

inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" localvimrc

let g:localvimrc_sandbox = 0
let g:localvimrc_ask = 0

" NERDTree

let g:NERDTreeWinSize = 40

" Syntastic

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_python_checkers = ['python', 'flake8']

" Startify

let g:startify_change_to_vcs_root = 1

" Braceless

autocmd FileType python BracelessEnable +indent
