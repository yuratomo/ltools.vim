if exists('g:Lquick_loaded') && g:Lquick_loaded == 1
  finish
endif

command! -nargs=? Lquick :call Lquick#do(<f-args>)

let g:Lquick_update = 0

augroup Lquick
  au!
  au QuickFixCmdPost * call Lquick#update()
augroup END

function! Lquick#update()
  let g:Lquick_update = 1
endfunction

let g:Lquick_loaded = 1
