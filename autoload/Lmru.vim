let s:plugin = Lcore#initPlugin('Lmru')
function! Lmru#init()
endfunction

function! Lmru#do(...)
  call Lcore#show(s:plugin, join(a:000, ' '))
endfunction

function! s:plugin.preproc()
  syn match mruDirHilight /^.*\\/
  syn match mruExtHilight /\.\w*$/
endfunction

function! s:plugin.list()
  if s:plugin.is_sort == 1
    let list = sort(copy(s:plugin.items))
  else
    let list = copy(s:plugin.items)
  endif
  return list
endfunction

function! s:plugin.open(line)
  wincmd p
  exe 'edit ' . a:line
endfunction

function! s:plugin.delete(line)
  let pos = index(s:plugin.items, a:line)
  if pos >= 0
    call remove(s:plugin.items, pos)
  endif
  setl modifiable
  delete
  setl nomodifiable
endfunction

" for AutoCommand

function! Lmru#load()
  if s:plugin.init == 1
    return
  endif
  let s:plugin.init = 1
  if filereadable(g:Lmru_file)
    let s:plugin.items = filter(readfile(g:Lmru_file), "v:val != ''")
  endif
  hi link mruDirHilight Statement
  hi link mruExtHilight Comment
endfunction

function! Lmru#save()
  call writefile(s:plugin.items, g:Lmru_file)
endfunction

function! Lmru#regist()
  call Lmru#load()
  let line = expand('%:p')
  let pos = index(s:plugin.items, line)
  if pos >= 0
    call remove(s:plugin.items, pos)
  elseif len(s:plugin.items) >= g:Lmru_max_count
    call remove(s:plugin.items, len(s:plugin.items)-1)
  endif
  call insert(s:plugin.items, line, 0)
  call Lmru#save()
endfunction

