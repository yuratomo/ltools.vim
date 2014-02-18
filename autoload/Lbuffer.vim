let s:plugin = Lcore#initPlugin('Lbuf')
function! Lbuffer#init()
  let s:title = printf(g:Lcore_title_format, s:plugin.title)
endfunction

function! Lbuffer#do(...)
  hi def link LbufferSynNum  Number
  hi def link LbufferSynMode Identifier
  hi def link LbufferSynHide String
  hi def link LbufferSynCur  Type
  call Lcore#show(s:plugin, join(a:000, ' '))
endfunction

function! s:plugin.preproc()
  syn match LbufferSynNum    /^\s*\d\+/
  syn match LbufferSynMode   /^\s*\d\+.\{4}+.*/
  syn match LbufferSynHide   /^\s*\d\+.\{2}h.*/
  syn match LbufferSynCur    /^\s*\d\+.%.*/
endfunction

function! s:plugin.list()
  try 
    redir => bufoutput
      silent! ls
    redir END
  catch /.*/
    let bufoutput = ''
  endtry

  let lines = split(bufoutput, '\n')
  let s:plugin.items = []
  for line in lines
    if match(line, s:title) < 0
      call add(s:plugin.items, line)
    endif
  endfor

  if s:plugin.is_sort == 1
    let list = sort(copy(s:plugin.items), "Lbuffer#sortFunc")
  else
    let list = copy(s:plugin.items)
  endif
  return list
endfunction

function! Lbuffer#sortFunc(i1, i2)
  if a:i1[10:] > a:i2[10:]
    return 1
  elseif a:i1[10:] < a:i2[10:]
    return -1
  endif
  return 0
endfunction

function! s:plugin.open(line)
  wincmd p
  exe 'b '.split(a:line, ' ')[0]
endfunction

function! s:plugin.delete(line)
  exe 'bd '.split(a:line, ' ')[0]
  setlocal modifiable
  delete
  setlocal nomodifiable
endfunction

let g:Lbuffer_loaded = 1

