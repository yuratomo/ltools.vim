let s:plugin = Lcore#initPlugin('Lbookmark')
function! Lbookmark#init()
endfunction

function! Lbookmark#do()
  hi link LbookmarkDirHilight  Statement
  hi link LbookmarkExtHilight  Comment
  hi link LbookmarkNameHilight String
  call Lcore#show(s:plugin, join(a:000, ' '))
endfunction

function! s:plugin.preproc()
  syn match LbookmarkDirHilight  /.*\\/
  syn match LbookmarkExtHilight  /\.\w*$/
  syn match LbookmarkNameHilight /^[^\[]\{32\}/
  nnoremap <buffer> r :call Lbookmark#rename()<CR>
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
  exe ':e '.a:line[32:]
endfunction

function! s:plugin.delete(line)
  let pos = index(s:plugin.items, a:line)
  if pos >= 0
    call remove(s:plugin.items, pos)
  endif
  setlocal modifiable
  delete
  setlocal nomodifiable
  call Lbookmark#save()
endfunction

" for Regist

function! Lbookmark#regist(...)
  if a:0 == 1
    let target = a:1
  else
    let target = expand('%:p')
  endif
  let name = input('Input bookmark name for "'. target .'":', '')
  if name == ''
    return
  endif
  let line = printf('%-32s', name).target
  let pos = index(s:plugin.items, line)
  if pos >= 0
    call remove(s:plugin.items, pos)
  endif
  call insert(s:plugin.items, line, 0)
  call Lbookmark#save()
endfunction

function! Lbookmark#rename()
  let pos = index(s:plugin.items, getline('.'))
  if pos != -1
    let name = input('Input bookmark name:', split(s:plugin.items[pos][0:31], ' ')[0])
    let s:plugin.items[pos] = printf('%-32s', name).s:plugin.items[pos][32:]
  endif
  let cl = line('.')
  let cc = col('.')
  call Lcore#update()
  call cursor(cl,cc)
  call Lbookmark#save()
endfunction

function! Lbookmark#load()
  if filereadable(g:Lbookmark_file)
    let s:plugin.items = readfile(g:Lbookmark_file)
  endif
endfunction

function! Lbookmark#save()
  call writefile(s:plugin.items, g:Lbookmark_file)
endfunction

let g:Lbookmark_loaded = 1
