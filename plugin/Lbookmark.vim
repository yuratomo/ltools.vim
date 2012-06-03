" FILE: Lbookmark.vim
" AUTHOR:  yuratomo
" Last Modified: 31 Jan 2012.

if exists('g:Lbookmark_loaded') && g:Lbookmark_loaded == 1
  finish
endif

if !exists("g:Lbookmark_file")
  let g:Lbookmark_file = $home.'\\.vim_bookmark'
endif

command! -nargs=? Lbookmark :call Lbookmark#do()
command! -nargs=0 LRegistBookmark :call Lbookmark#regist()

let g:Lbookmark_loaded = 1
