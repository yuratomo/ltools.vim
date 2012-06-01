" FILE: Loutline.vim
" AUTHOR:  yuratomo
" Last Modified: 31 Jan 2012.
" Version: 0.0.1

if exists('g:Loutline_loaded') && g:Loutline_loaded == 1
  finish
endif
if !exists('g:Lcore_loaded') || g:Lcore_loaded == 0
  runtime plugin/Lcore.vim
endif

let g:Loutline_title = Lcore#RegistPlugin('Loutline')
let g:Loutline_ext  = ''
let g:Loutline_lines = []
let g:Loutline_first_pos = 0
let g:Loutline_last_file = ''

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
  let g:Loutline_mapping.java   = '\(^class\|^\t[a-zA-Z0-9_ ]*\(\|::\)[\~a-zA-Z1-9_\/=]*\s*([^;]*$\)'
endif
if !exists('g:Loutline_disable_default_as')
  let g:Loutline_mapping.as   = '\(\<function\>\|\<class\>\|\<package\>\)'
  let g:Loutline_mapping.mxml = '^[ \t]\{0,3\}<'
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

command! -nargs=? Loutline :call Loutline#ShowNoCache(<f-args>)

function! Loutline#ShowNoCache()
  let g:Loutline_last_file = ''
  call Loutline#Show()
endfunction

function! Loutline#Show()
  call Lcore#Close()
  if exists("a:1")
    let g:Lcore_refine_word = a:1
  endif
  let g:Loutline_ext = expand('%:e')
  if !has_key(g:Loutline_mapping, g:Loutline_ext)
    return
  endif
  call Loutline#CreateList()
  exe ':topleft new '.g:Loutline_title
  exe ':res '.g:Lcore_line_num
  silent call Loutline#Update()
  call cursor(g:Loutline_first_pos, 1)
  exe 'setl ft='.g:Loutline_ext
  call Lcore#CommonSetting()
  call Lcore#HilightTitle()
endfunction

function! Loutline#CreateList()
  let curfile = expand('%:p')
  if g:Loutline_last_file == curfile
    return
  endif
  let g:Loutline_last_file = curfile
  let g:Loutline_lines = []
  let g:Loutline_first_pos = 0
  let idx = 2
  let total = 1
  let cline = line('.')
  let lines = getline(1, '$')
  for line in lines
    if match(line, g:Loutline_mapping[g:Loutline_ext]) >= 0
      call add(g:Loutline_lines, printf("%6d", total).' '.line)
      let idx = idx + 1
      if cline > total
        let g:Loutline_first_pos = idx
      endif
    endif
    let total = total + 1
  endfor
endfunction

function! Loutline#Update()
  setlocal modifiable
  let list = copy(g:Loutline_lines)
  call Lcore#Refine(list)
  call Lcore#Clear()
  call Lcore#Show(list)
  setlocal nomodifiable
endfunction

function! Loutline#Open(line)
  wincmd p
  if expand('%:p') != g:Loutline_last_file
    exe ':e '.g:Loutline_last_file
  endif
  exe ':'.split(a:line, ' ')[0]
  normal zt
endfunction

function! Loutline#Sort()
endfunction

function! Loutline#Delete()
endfunction

let g:Loutline_loaded = 1
