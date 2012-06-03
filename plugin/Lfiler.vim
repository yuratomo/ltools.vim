"=============================================================================
" File: Lfiler.vim
" Author: yuratomo
" Last Modified: 2012.06.01
" Version: 0.1.0
" Usage: input :Lfier<CR> and push F1 key.
"=============================================================================
if !has('win32')
  echoerr 'Lfiler can not load.' | finish
endif

command! -nargs=* -complete=dir Lfiler :call Lfiler#Show(1, <f-args>)
command! -nargs=* -complete=dir LFiler :call Lfiler#Show(0, <f-args>)

if !exists('g:Lfiler_disable_default_explorer')
  augroup FileExplorer
   au!
  augroup END
  augroup LFiler
    au BufEnter * silent! call Lfiler#do(1, expand("<amatch>"))
  augroup END
endif

if !exists("g:Lfiler_bookmark_file")
  let g:Lfiler_bookmark_file = $home.'\\.vim_bookmark'
endif

let g:Lfiler_loaded = 1
