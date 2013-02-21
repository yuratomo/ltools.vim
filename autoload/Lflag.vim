
function! Lflag#Toggle()
  let line = line('.')
  if !exists('b:Lflag_data')
    call s:prepare()
  endif
  if exists('b:Lflag_data.marks.' . line)
    call matchdelete(b:Lflag_data.marks[line])
    unlet b:Lflag_data.marks[line]
  else
    let b:Lflag_data.marks[line] = matchadd('LflagSelect', '\%' . line . 'l')
  endif
  redraw
endfunction

function! NumberCompare(i1, i2)
   return a:i1 - a:i2
endfunc
function! NumberCompareReverse(i1, i2)
   return a:i2 - a:i1
endfunc

function! Lflag#Next()
  if !exists('b:Lflag_data')
    return
  endif
  let line = line('.')
  for l in sort(keys(b:Lflag_data.marks), 'NumberCompare')
    if l > line
      call cursor(l, 0)
      break
    endif
  endfor
endfunction

function! Lflag#Prev()
  if !exists('b:Lflag_data')
    return
  endif
  let line = line('.')
  for l in sort(keys(b:Lflag_data.marks), 'NumberCompareReverse')
    if l < line
      call cursor(l, 0)
      break
    endif
  endfor
endfunction

function! Lflag#Refresh()
  if exists('b:Lflag_data')
    for line in keys(b:Lflag_data.marks)
      call matchdelete(b:Lflag_data.marks[line])
      let b:Lflag_data.marks[line] = matchadd('LflagSelect', '\%' . line . 'l')
    endfor
  endif
endfunction

function! Lflag#BufWinLeave()
  call s:clean()
endfunction

function! Lflag#BufWinEnter()
  call Lflag#Refresh()
endfunction

function! Lflag#Clear()
  call s:clean()
  if exists('b:Lflag_data')
    unlet b:Lflag_data
  endif
  augroup Lflag
    au!
  augroup END
  redraw
endfunction

function! s:prepare()
  let b:Lflag_data = {'marks':{}}
  if !hlexists('LflagSelect')
    hi LflagSelect  guibg=#001080 guifg=NONE gui=BOLD
  endif
  augroup Lflag
    au!
    au BufWinEnter <buffer> silent! call Lflag#BufWinEnter()
    au BufWinLeave <buffer> silent! call Lflag#BufWinLeave()
  augroup END
endfunction

function! s:clean()
  if exists('b:Lflag_data')
    for line in keys(b:Lflag_data.marks)
      try
        call matchdelete(b:Lflag_data.marks[line])
      catch /.*/
      endtry
    endfor
  endif
endfunction

