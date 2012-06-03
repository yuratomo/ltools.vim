" FILE: Lmru.vim
" AUTHOR:  yuratomo
" Last Modified: 31 Jan 2012.

if exists('g:Lmru_loaded') && g:Lmru_loaded == 1
  finish
endif

if !exists("g:Lmru_max_count")
  let g:Lmru_max_count = 100
endif
if !exists("g:Lmru_file")
  let g:Lmru_file = $home.'\\.vim_mru'
endif

command! -nargs=? Lmru :call Lmru#do(<f-args>)

augroup Lmru
  autocmd!
  autocmd VimEnter     * call Lmru#load()
  autocmd VimLeave     * call Lmru#save()
  autocmd BufRead      * call Lmru#regist()
  autocmd BufWritePost * call Lmru#regist()
augroup END

let g:Lmru_loaded = 1
