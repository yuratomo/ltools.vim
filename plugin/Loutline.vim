" FILE: Loutline.vim
" AUTHOR:  yuratomo
" Last Modified: 31 Jan 2012.
" Version: 0.0.1

if exists('g:Loutline_loaded') && g:Loutline_loaded == 1
  finish
endif

if !exists('g:Loutline_mapping')
  let g:Loutline_mapping = {}
endif
if !exists('g:Loutline_disable_default_c')
  let g:Loutline_mapping.c   = '^[^ \t/].*[^\/][a-zA-Z0-9_]*\(\|::\)[\~a-zA-Z1-9_\/=]*\s*([^;]*$'
  let g:Loutline_mapping.C   = '^[^ \t/].*[^\/][a-zA-Z0-9_]*\(\|::\)[\~a-zA-Z1-9_\/=]*\s*([^;]*$'
  let g:Loutline_mapping.cpp = '^[^ \t/].*[^\/][a-zA-Z0-9_]*\(\|::\)[\~a-zA-Z1-9_\/=]*\s*([^;]*$'
  let g:Loutline_mapping.h   = '\(^[a-zA-Z0-9]\|#i\)'
endif
if !exists('g:Loutline_disable_default_java')
  let g:Loutline_mapping.java   = '\(^class\|^\s[a-zA-Z0-9_ ]*\(\|::\)[\~a-zA-Z1-9_\/=]*\s*([^;]*$\)'
endif
if !exists('g:Loutline_disable_default_as')
  let g:Loutline_mapping.as   = '\(\<function\>\|\<class\>\|\<package\>\)'
  let g:Loutline_mapping.mxml = '^\s\{0,3\}<'
endif
if !exists('g:Loutline_disable_default_vim')
  let g:Loutline_mapping.vim  = '^function!'
endif
if !exists('g:Loutline_disable_default_txt')
  let g:Loutline_mapping.txt  = '^[\[ym]¡ ž›œ'
endif
if !exists('g:Loutline_disable_default_ini')
  let g:Loutline_mapping.ini  = '^\[.*'
endif
if !exists('g:Loutline_disable_default_cs')
  let g:Loutline_mapping.cs   = '\(\<class\>\|^\s\+[a-zA-Z1-9_]\+\s\+[\~a-zA-Z0-9_]\+\(\|\s\+[|~a-zA-Z0-9]\+\)\+(\)'
endif

command! -nargs=? Loutline :call Loutline#do(<f-args>)

let g:Loutline_loaded = 1
