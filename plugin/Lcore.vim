" FILE: Lcore.vim
" AUTHOR:  yuratomo
" Last Modified: 31 Jan 2012.
" Version: 0.2.0

if exists('g:Lcore_loaded') && g:Lcore_loaded == 1
  finish
endif

let g:Lcore_title_format = "--%s--"
let g:Lcore_refine_prefix = 'refine='
if !exists('g:Lcore_plugins')
  let g:Lcore_plugins = []
endif
call extend( g:Lcore_plugins, [ 'Lmru', 'Lbuffer', 'Lbookmark', 'Loutline'])

if !exists('g:Lcore_line_num')
  let g:Lcore_line_num = 20
endif

command! -nargs=0 Lclose :call Lcore#close()

let g:Lcore_loaded = 1
