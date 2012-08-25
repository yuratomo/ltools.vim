if exists('g:Ltaglist_loaded') && g:Ltaglist_loaded == 1
  finish
endif

command! -nargs=? Ltag     :call Ltaglist#do(<f-args>)
command! -nargs=? Ltaglist :call Ltaglist#do('')

let g:Ltaglist_loaded = 1
