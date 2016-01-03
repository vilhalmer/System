" Plugin configuration

" Unite

call unite#filters#matcher_default#use(['matcher_fuzzy'])

augroup UniteOverrides
    autocmd!
    autocmd FileType unite call s:unite_settings()
augroup end

function! s:unite_settings()
    imap <buffer> <ESC> <Plug>(unite_exit)
endfunction

" localvimrc

let g:localvimrc_sandbox = 0
let g:localvimrc_ask = 0

" NERDTree

let g:NERDTreeWinSize = 40

