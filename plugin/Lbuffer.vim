" FILE: Lbuffer.vim
" AUTHOR:  yuratomo
" Last Modified: 31 Jan 2012.
" Version: 0.0.1

if exists('g:Lbuffer_loaded') && g:Lbuffer_loaded == 1
  finish
endif
if !exists('g:Lcore_loaded') || g:Lcore_loaded == 0
  runtime plugin/Lcore.vim
endif

let g:Lbuffer_title = Lcore#RegistPlugin('Lbuffer')
let g:Lbuffer_list = []
let g:Lbuffer_sort = 1

command! -nargs=? Lbuffer :call Lbuffer#Show(<f-args>)

function! Lbuffer#Show()
  call Lcore#Close()
  if exists("a:1")
    let g:Lcore_refine_word = a:1
  endif
  silent call Lbuffer#CreateList()
  exe ':topleft new '.g:Lbuffer_title
  exe ':res '.g:Lcore_line_num
  silent call Lbuffer#Update()
  call Lcore#CommonSetting()
  call Lcore#HilightTitle()
  syn match LbufferSynNum    /^\s*\d\+/
  syn match LbufferSynMode   /^\s*\d\+.\{4}+.*/
  syn match LbufferSynHide   /^\s*\d\+.\{2}h.*/
  syn match LbufferSynCur    /^\s*\d\+.%.*/
  hi def link LbufferSynNum  Number
  hi def link LbufferSynMode Identifier
  hi def link LbufferSynHide String
  hi def link LbufferSynCur  Type
endfunction

function! Lbuffer#CreateList()
  try 
    redir => bufoutput
      ls
    redir END
  catch /.*/
    let bufoutput = ''
  endtry

  let lines = split(bufoutput, '\n')
  let g:Lbuffer_list = []
  for line in lines
    if match(line, g:Lbuffer_title) < 0
      call add(g:Lbuffer_list, line)
    endif
  endfor
endfunction

function! Lbuffer#Update()
  setlocal modifiable
  if g:Lbuffer_sort == 1
    let list = sort(copy(g:Lbuffer_list), "Lbuffer#SortFunc")
  else
    let list = copy(g:Lbuffer_list)
  endif
  call Lcore#Refine(list)
  call Lcore#Clear()
  call Lcore#Show(list)
  call Lcore#SetCursorTop()
  setlocal nomodifiable
endfunction

function! Lbuffer#SortFunc(i1, i2)
  if a:i1[10:] > a:i2[10:]
    return 1
  elseif a:i1[10:] < a:i2[10:]
    return -1
  endif
  return 0
endfunction

function! Lbuffer#Open(line)
  wincmd p
  exe ':b '.split(a:line, ' ')[0]
endfunction

function! Lbuffer#Delete()
  let line = getline('.')
  exe ':bd '.split(line, ' ')[0]
  setlocal modifiable
  delete
  setlocal nomodifiable
endfunction

function! Lbuffer#Sort()
  let g:Lbuffer_sort = !g:Lbuffer_sort
  silent call Lbuffer#Update()
endfunction

let g:Lbuffer_loaded = 1
