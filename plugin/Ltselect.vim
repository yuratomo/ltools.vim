" FILE: Ltselectc.vim
" AUTHOR:  yuratomo

if exists('g:Ltselect_loaded') && g:Ltselect_loaded == 1
  finish
endif

command! -nargs=? Ltselect :call Ltselect#do()

let g:Ltselect_loaded = 1
