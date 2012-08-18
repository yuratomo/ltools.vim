" FILE: Lsearch.vim
" AUTHOR:  yuratomo

if exists('g:Lsearch_loaded') && g:Lsearch_loaded == 1
  finish
endif

command! -nargs=* Lsearch      :call Lsearch#Search(<f-args>)

let g:Lsearch_loaded = 1
