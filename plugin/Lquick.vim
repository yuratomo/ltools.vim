if exists('g:Lquick_loaded') && g:Lquick_loaded == 1
  finish
endif

command! -nargs=? Lquick :call Lquick#do(<f-args>)

let g:Lquick_loaded = 1
