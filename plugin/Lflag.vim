" FILE: Lflag.vim
" AUTHOR:  yuratomo

if exists('g:Lflag_loaded') && g:Lflag_loaded == 1
  finish
endif

command! -nargs=0 Lflag      :call Lflag#Toggle()
command! -nargs=0 LflagNext  :call Lflag#Next()
command! -nargs=0 LflagPrev  :call Lflag#Prev()
command! -nargs=0 LflagClear :call Lflag#Clear()

nnoremap <Plug>(Lflag-toggle) :<C-u>call Lflag#Toggle()<CR>
nnoremap <Plug>(Lflag-next)   :<C-u>call Lflag#Next()<CR>
nnoremap <Plug>(Lflag-prev)   :<C-u>call Lflag#Prev()<CR>

if !exists('g:Lflag_disable_default_keymap') || g:Lflag_disable_default_keymap == 0
  nmap <c-F2>  <Plug>(Lflag-toggle)
  nmap <F2>    <Plug>(Lflag-next)
  nmap <s-F2>  <Plug>(Lflag-prev)
endif

let g:Lflag_loaded = 1
