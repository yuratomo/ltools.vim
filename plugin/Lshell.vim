" FILE: Lshell.vim
" AUTHOR:  yuratomo

if exists('g:Lshell_loaded') && g:Lshell_loaded == 1
  finish
endif

command! -nargs=? Lshell :call Lshell#open(<f-args>)

let g:Lshell_loaded = 1
