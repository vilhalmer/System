" Plugin configuration

" Unite

call unite#filters#matcher_default#use(['matcher_fuzzy'])

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

