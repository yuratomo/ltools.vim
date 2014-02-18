" FILE: Lbuffer.vim
" AUTHOR:  yuratomo
" Last Modified: 31 Jan 2012.

if exists('g:Lbuffer_loaded') && g:Lbuffer_loaded == 1
  finish
endif

command! -nargs=? Lbuffer :call Lbuffer#do(<f-args>)

let g:Lbuffer_loaded = 1

